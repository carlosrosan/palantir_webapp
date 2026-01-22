"""
ETL Script for Failure Probability Feature Extraction

This script extracts features from:
- plc_sensor_readings: sensor readings, warnings, critical statuses
- assets_faliures: historical failure data, severity, resolution status
- mantainance_tasks: maintenance task history, completion times, status

Output: Creates/updates the faliure_probability_base table in MySQL with feature vectors
"""

import mysql.connector
from mysql.connector import Error
from datetime import datetime, timedelta
import os
from dotenv import load_dotenv
import sys
import pandas as pd
import numpy as np

# Load environment variables
load_dotenv()

# Database configuration
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'database': os.getenv('DB_NAME', 'palantir_maintenance'),
    'user': os.getenv('DB_USER', 'root'),
    'password': os.getenv('DB_PASSWORD', ''),
    'port': int(os.getenv('DB_PORT', 3306))
}


def extract_features_for_asset(asset_id, connection):
    """
    Extract all features for a specific asset from the three source tables.
    
    Returns a dictionary with all extracted features.
    """
    cursor = connection.cursor(dictionary=True)
    
    try:
        # Get asset basic information
        cursor.execute("""
            SELECT asset_id, asset_name, asset_type, installation_date, status
            FROM assets
            WHERE asset_id = %s
        """, (asset_id,))
        asset = cursor.fetchone()
        
        if not asset:
            return None
        
        installation_date = asset['installation_date']
        asset_age_days = (datetime.now().date() - installation_date).days
        
        # ===== FEATURES FROM plc_sensor_readings =====
        
        # Recent sensor readings statistics (last 30 days)
        cursor.execute("""
            SELECT 
                COUNT(*) as total_readings,
                COUNT(CASE WHEN status = 'warning' THEN 1 END) as warning_count,
                COUNT(CASE WHEN status = 'critical' THEN 1 END) as critical_count,
                AVG(CASE WHEN status = 'normal' THEN reading_value END) as avg_normal_value,
                AVG(CASE WHEN status = 'warning' THEN reading_value END) as avg_warning_value,
                AVG(CASE WHEN status = 'critical' THEN reading_value END) as avg_critical_value,
                MAX(reading_value) as max_reading_value,
                MIN(reading_value) as min_reading_value,
                STDDEV(reading_value) as std_reading_value
            FROM plc_sensor_readings
            WHERE asset_id = %s
            AND reading_timestamp >= DATE_SUB(NOW(), INTERVAL 30 DAY)
        """, (asset_id,))
        sensor_stats = cursor.fetchone()
        
        # Sensor readings by type (last 30 days)
        cursor.execute("""
            SELECT 
                sensor_type,
                COUNT(*) as count,
                AVG(reading_value) as avg_value,
                COUNT(CASE WHEN status IN ('warning', 'critical') THEN 1 END) as alert_count
            FROM plc_sensor_readings
            WHERE asset_id = %s
            AND reading_timestamp >= DATE_SUB(NOW(), INTERVAL 30 DAY)
            GROUP BY sensor_type
        """, (asset_id,))
        sensor_by_type = cursor.fetchall()
        
        # Create sensor type features
        sensor_features = {}
        for row in sensor_by_type:
            sensor_type = row['sensor_type'].lower().replace(' ', '_')
            sensor_features[f'sensor_{sensor_type}_count'] = row['count'] or 0
            sensor_features[f'sensor_{sensor_type}_avg'] = float(row['avg_value'] or 0)
            sensor_features[f'sensor_{sensor_type}_alerts'] = row['alert_count'] or 0
        
        # ===== FEATURES FROM assets_faliures =====
        
        # Failure history (last 365 days)
        cursor.execute("""
            SELECT 
                COUNT(*) as failure_count,
                COUNT(CASE WHEN severity = 'critical' THEN 1 END) as critical_failures,
                COUNT(CASE WHEN severity = 'high' THEN 1 END) as high_failures,
                COUNT(CASE WHEN severity = 'medium' THEN 1 END) as medium_failures,
                COUNT(CASE WHEN severity = 'low' THEN 1 END) as low_failures,
                AVG(downtime_hours) as avg_downtime,
                SUM(downtime_hours) as total_downtime,
                COUNT(CASE WHEN resolved = FALSE THEN 1 END) as unresolved_failures,
                MAX(failure_date) as last_failure_date,
                MIN(failure_date) as first_failure_date
            FROM assets_faliures
            WHERE asset_id = %s
            AND failure_date >= DATE_SUB(NOW(), INTERVAL 365 DAY)
        """, (asset_id,))
        failure_stats = cursor.fetchone()
        
        # Days since last failure
        days_since_last_failure = None
        if failure_stats['last_failure_date']:
            days_since_last_failure = (datetime.now() - failure_stats['last_failure_date']).days
        
        # Failure types distribution
        cursor.execute("""
            SELECT 
                failure_type,
                COUNT(*) as count
            FROM assets_faliures
            WHERE asset_id = %s
            AND failure_date >= DATE_SUB(NOW(), INTERVAL 365 DAY)
            GROUP BY failure_type
        """, (asset_id,))
        failure_types = cursor.fetchall()
        
        failure_type_features = {}
        for row in failure_types:
            failure_type = row['failure_type'].lower().replace(' ', '_')
            failure_type_features[f'failure_{failure_type}_count'] = row['count'] or 0
        
        # ===== FEATURES FROM mantainance_tasks =====
        
        # Maintenance task statistics (last 365 days)
        cursor.execute("""
            SELECT 
                COUNT(*) as total_tasks,
                COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed_tasks,
                COUNT(CASE WHEN status = 'in_progress' THEN 1 END) as in_progress_tasks,
                COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending_tasks,
                AVG(estimated_hours) as avg_estimated_hours,
                AVG(actual_hours) as avg_actual_hours,
                SUM(actual_hours) as total_hours,
                MAX(end_time) as last_completion_date,
                MIN(start_time) as first_task_date
            FROM mantainance_tasks mt
            INNER JOIN mantainance_orders mo ON mt.order_id = mo.order_id
            WHERE mo.asset_id = %s
            AND (mt.start_time >= DATE_SUB(NOW(), INTERVAL 365 DAY)
                 OR mt.created_at >= DATE_SUB(NOW(), INTERVAL 365 DAY))
        """, (asset_id,))
        task_stats = cursor.fetchone()
        
        # Days since last completed task
        days_since_last_task = None
        if task_stats['last_completion_date']:
            days_since_last_task = (datetime.now() - task_stats['last_completion_date']).days
        
        # Maintenance order statistics
        cursor.execute("""
            SELECT 
                COUNT(*) as total_orders,
                COUNT(CASE WHEN order_type = 'preventive' THEN 1 END) as preventive_orders,
                COUNT(CASE WHEN order_type = 'corrective' THEN 1 END) as corrective_orders,
                COUNT(CASE WHEN order_type = 'emergency' THEN 1 END) as emergency_orders,
                COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed_orders,
                AVG(estimated_cost) as avg_estimated_cost,
                AVG(actual_cost) as avg_actual_cost,
                SUM(actual_cost) as total_actual_cost,
                MAX(completion_date) as last_order_completion
            FROM mantainance_orders
            WHERE asset_id = %s
            AND (scheduled_date >= DATE_SUB(NOW(), INTERVAL 365 DAY)
                 OR created_at >= DATE_SUB(NOW(), INTERVAL 365 DAY))
        """, (asset_id,))
        order_stats = cursor.fetchone()
        
        # Days since last order completion
        days_since_last_order = None
        if order_stats['last_order_completion']:
            days_since_last_order = (datetime.now() - order_stats['last_order_completion']).days
        
        # Compile all features
        features = {
            'asset_id': asset_id,
            'extraction_date': datetime.now(),
            
            # Asset basic info
            'asset_age_days': asset_age_days,
            'asset_status': asset['status'],
            
            # Sensor features
            'sensor_total_readings_30d': sensor_stats['total_readings'] or 0,
            'sensor_warning_count_30d': sensor_stats['warning_count'] or 0,
            'sensor_critical_count_30d': sensor_stats['critical_count'] or 0,
            'sensor_avg_normal_value': float(sensor_stats['avg_normal_value'] or 0),
            'sensor_avg_warning_value': float(sensor_stats['avg_warning_value'] or 0),
            'sensor_avg_critical_value': float(sensor_stats['avg_critical_value'] or 0),
            'sensor_max_value': float(sensor_stats['max_reading_value'] or 0),
            'sensor_min_value': float(sensor_stats['min_reading_value'] or 0),
            'sensor_std_value': float(sensor_stats['std_reading_value'] or 0),
            
            # Failure features
            'failure_count_365d': failure_stats['failure_count'] or 0,
            'failure_critical_count': failure_stats['critical_failures'] or 0,
            'failure_high_count': failure_stats['high_failures'] or 0,
            'failure_medium_count': failure_stats['medium_failures'] or 0,
            'failure_low_count': failure_stats['low_failures'] or 0,
            'failure_avg_downtime': float(failure_stats['avg_downtime'] or 0),
            'failure_total_downtime': float(failure_stats['total_downtime'] or 0),
            'failure_unresolved_count': failure_stats['unresolved_failures'] or 0,
            'days_since_last_failure': days_since_last_failure,
            
            # Maintenance task features
            'task_total_365d': task_stats['total_tasks'] or 0,
            'task_completed_count': task_stats['completed_tasks'] or 0,
            'task_in_progress_count': task_stats['in_progress_tasks'] or 0,
            'task_pending_count': task_stats['pending_tasks'] or 0,
            'task_avg_estimated_hours': float(task_stats['avg_estimated_hours'] or 0),
            'task_avg_actual_hours': float(task_stats['avg_actual_hours'] or 0),
            'task_total_hours': float(task_stats['total_hours'] or 0),
            'days_since_last_task': days_since_last_task,
            
            # Maintenance order features
            'order_total_365d': order_stats['total_orders'] or 0,
            'order_preventive_count': order_stats['preventive_orders'] or 0,
            'order_corrective_count': order_stats['corrective_orders'] or 0,
            'order_emergency_count': order_stats['emergency_orders'] or 0,
            'order_completed_count': order_stats['completed_orders'] or 0,
            'order_avg_estimated_cost': float(order_stats['avg_estimated_cost'] or 0),
            'order_avg_actual_cost': float(order_stats['avg_actual_cost'] or 0),
            'order_total_actual_cost': float(order_stats['total_actual_cost'] or 0),
            'days_since_last_order': days_since_last_order,
        }
        
        # Add sensor type features
        features.update(sensor_features)
        
        # Add failure type features
        features.update(failure_type_features)
        
        return features
        
    finally:
        cursor.close()


def create_feature_dataframe(connection):
    """
    Create a dataframe with features for all assets and save to faliure_probability_base table.
    """
    cursor = connection.cursor()
    
    try:
        # Get all assets
        cursor.execute("SELECT asset_id FROM assets")
        assets = cursor.fetchall()
        
        all_features = []
        
        for (asset_id,) in assets:
            features = extract_features_for_asset(asset_id, connection)
            if features:
                all_features.append(features)
                print(f"Extracted features for asset_id {asset_id}")
        
        if not all_features:
            print("No features extracted. Exiting.")
            return
        
        # Create DataFrame
        df = pd.DataFrame(all_features)
        
        # Replace NaN with None for SQL compatibility
        df = df.replace({np.nan: None})
        
        # Get valid columns from database table schema
        cursor.execute("""
            SELECT COLUMN_NAME 
            FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_SCHEMA = %s 
            AND TABLE_NAME = 'faliure_probability_base'
            AND COLUMN_NAME NOT IN ('base_id', 'created_at', 'updated_at')
        """, (DB_CONFIG['database'],))
        valid_columns = [row[0] for row in cursor.fetchall()]
        
        # Filter feature columns to only include those that exist in the table
        feature_columns = [col for col in df.columns 
                          if col in valid_columns and col not in ['asset_id', 'extraction_date']]
        
        # Clear existing data (optional - you might want to keep historical data)
        cursor.execute("TRUNCATE TABLE faliure_probability_base")
        
        # Insert data into database
        for _, row in df.iterrows():
            # Build column list and values (only include valid columns)
            columns = ['asset_id', 'extraction_date'] + feature_columns
            placeholders = ['%s'] * len(columns)
            values = [row['asset_id'], row['extraction_date']] + [row.get(col) for col in feature_columns]
            
            insert_sql = f"""
                INSERT INTO faliure_probability_base 
                ({', '.join(columns)})
                VALUES ({', '.join(placeholders)})
                ON DUPLICATE KEY UPDATE
                    extraction_date = VALUES(extraction_date),
                    {', '.join([f'{col} = VALUES({col})' for col in feature_columns])},
                    updated_at = CURRENT_TIMESTAMP
            """
            
            cursor.execute(insert_sql, values)
        
        connection.commit()
        print(f"\nSuccessfully saved {len(df)} asset feature vectors to faliure_probability_base table")
        print(f"Total features: {len(feature_columns)}")
        
    except Error as e:
        print(f"Error creating feature dataframe: {e}")
        connection.rollback()
        raise
    finally:
        cursor.close()


def main():
    """Main ETL execution function."""
    connection = None
    
    try:
        print("Connecting to MySQL database...")
        connection = mysql.connector.connect(**DB_CONFIG)
        
        if connection.is_connected():
            print(f"Connected to MySQL database: {DB_CONFIG['database']}")
            print("Starting failure probability feature extraction ETL...")
            
            create_feature_dataframe(connection)
            
            print("\nETL process completed successfully!")
            
    except Error as e:
        print(f"Database error: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
    finally:
        if connection and connection.is_connected():
            connection.close()
            print("MySQL connection closed")


if __name__ == "__main__":
    main()
