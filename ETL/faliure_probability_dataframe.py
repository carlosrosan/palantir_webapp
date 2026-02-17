"""
ETL Script for Failure Probability Feature Extraction (Daily Granularity)

Features extracted (industrial predictive maintenance - pumps and motors):
- Mechanical vibration, RPM, power, electrical current, pressure, flow (from plc_sensor_readings, last 30d avg)
- Asset service days, asset service hours
- Days since last failure, days since last (visual) inspection

Output: faliure_probability_base table with one row per asset per day and 'faliure' = failure in next 7 days.
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
    'password': os.getenv('DB_PASSWORD', 'admin'),
    'port': int(os.getenv('DB_PORT', 3306))
}


def get_date_range(connection):
    """
    Get the date range for sensor readings to determine the days to process.
    """
    cursor = connection.cursor(dictionary=True)
    cursor.execute("""
        SELECT 
            -- MIN(DATE(reading_timestamp)) as min_date,
            -- MAX(DATE(reading_timestamp)) as max_date
            DATE('2022-01-01') as min_date,
            DATE('2023-01-31') as max_date
        -- FROM plc_sensor_readings
    """)
    result = cursor.fetchone()
    cursor.close()
    return result['min_date'], result['max_date']


def get_failure_dates(connection):
    """
    Get all failure dates for each asset.
    Returns a dictionary: {asset_id: [list of failure dates]}
    """
    cursor = connection.cursor(dictionary=True)
    cursor.execute("""
        SELECT DISTINCT asset_id, DATE(failure_date) as failure_date
        FROM assets_faliures
    """)
    failures = cursor.fetchall()
    cursor.close()
    
    failure_dict = {}
    for row in failures:
        asset_id = row['asset_id']
        failure_date = row['failure_date']
        if asset_id not in failure_dict:
            failure_dict[asset_id] = []
        failure_dict[asset_id].append(failure_date)
    
    return failure_dict


def check_failure_in_next_week(asset_id, reading_date, failure_dict):
    """
    Check if there's a failure in the next 7 days for the given asset.
    """
    if asset_id not in failure_dict:
        return False
    
    for failure_date in failure_dict[asset_id]:
        days_diff = (failure_date - reading_date).days
        if 0 < days_diff <= 7:  # Failure within next 7 days (not including today)
            return True
    return False


def _float_or_none(val):
    if val is None:
        return None
    try:
        return float(val)
    except (TypeError, ValueError):
        return None


def extract_features_for_asset_date(asset_id, reading_date, connection, failure_dict):
    """
    Extract only the required features for faliure_probability_base:
    mechanical_vibration, rpm, power, electrical_current, pressure, flow,
    asset_service_days, asset_service_hours, days_since_last_failure, days_since_last_inspection.
    """
    cursor = connection.cursor(dictionary=True)
    
    cursor.execute("""
        SELECT asset_id, installation_date
        FROM assets
        WHERE asset_id = %s
    """, (asset_id,))
    asset = cursor.fetchone()
    if not asset:
        cursor.close()
        return None
    
    installation_date = asset['installation_date']
    asset_service_days = (reading_date - installation_date).days
    asset_service_hours = asset_service_days * 24.0
    
    date_30_days_ago = reading_date - timedelta(days=30)
    
    # Sensor features: avg in last 30 days by type (vibration, rpm, power, current, pressure, flow)
    cursor.execute("""
        SELECT
            AVG(CASE WHEN sensor_type = 'vibration' THEN reading_value END) as mechanical_vibration,
            AVG(CASE WHEN sensor_type = 'rpm' THEN reading_value END) as rpm,
            AVG(CASE WHEN sensor_type = 'power' THEN reading_value END) as power,
            AVG(CASE WHEN sensor_type = 'current' THEN reading_value END) as electrical_current,
            AVG(CASE WHEN sensor_type = 'pressure' THEN reading_value END) as pressure,
            AVG(CASE WHEN sensor_type = 'flow' THEN reading_value END) as flow
        FROM plc_sensor_readings
        WHERE asset_id = %s
        AND DATE(reading_timestamp) BETWEEN %s AND %s
    """, (asset_id, date_30_days_ago, reading_date))
    sensor_row = cursor.fetchone()
    
    # Days since last failure
    cursor.execute("""
        SELECT MAX(DATE(failure_date)) as last_failure_date
        FROM assets_faliures
        WHERE asset_id = %s AND DATE(failure_date) <= %s
    """, (asset_id, reading_date))
    fail_row = cursor.fetchone()
    days_since_last_failure = None
    if fail_row and fail_row['last_failure_date']:
        days_since_last_failure = (reading_date - fail_row['last_failure_date']).days
    
    # Days since last (visual) inspection: last completed preventive order
    cursor.execute("""
        SELECT MAX(DATE(completion_date)) as last_inspection
        FROM mantainance_orders
        WHERE asset_id = %s AND order_type = 'preventive' AND status = 'completed'
        AND DATE(completion_date) <= %s
    """, (asset_id, reading_date))
    insp_row = cursor.fetchone()
    days_since_last_inspection = None
    if insp_row and insp_row['last_inspection']:
        days_since_last_inspection = (reading_date - insp_row['last_inspection']).days
    
    has_failure_next_week = check_failure_in_next_week(asset_id, reading_date, failure_dict)
    cursor.close()
    
    return {
        'asset_id': asset_id,
        'reading_date': reading_date,
        'faliure': has_failure_next_week,
        'mechanical_vibration': _float_or_none(sensor_row['mechanical_vibration']) if sensor_row else None,
        'rpm': _float_or_none(sensor_row['rpm']) if sensor_row else None,
        'power': _float_or_none(sensor_row['power']) if sensor_row else None,
        'electrical_current': _float_or_none(sensor_row['electrical_current']) if sensor_row else None,
        'pressure': _float_or_none(sensor_row['pressure']) if sensor_row else None,
        'flow': _float_or_none(sensor_row['flow']) if sensor_row else None,
        'asset_service_days': asset_service_days,
        'asset_service_hours': asset_service_hours,
        'days_since_last_failure': days_since_last_failure,
        'days_since_last_inspection': days_since_last_inspection,
    }


def create_feature_dataframe(connection):
    """
    Create a dataframe with features for all assets for each day and save to faliure_probability_base table.
    """
    cursor = connection.cursor()
    
    try:
        # Get all assets
        cursor.execute("SELECT asset_id FROM assets")
        assets = cursor.fetchall()
        
        # Get date range from sensor readings
        min_date, max_date = get_date_range(connection)
        print(f"Processing date range: {min_date} to {max_date}")
        
        # Get all failure dates for checking future failures
        failure_dict = get_failure_dates(connection)
        print(f"Loaded failure data for {len(failure_dict)} assets")
        
        all_features = []
        
        # Iterate through each day in the date range
        current_date = min_date
        while current_date <= max_date:
            for (asset_id,) in assets:
                features = extract_features_for_asset_date(asset_id, current_date, connection, failure_dict)
                if features:
                    all_features.append(features)
            
            print(f"Processed date: {current_date}")
            current_date += timedelta(days=1)
        
        if not all_features:
            print("No features extracted. Exiting.")
            return
        
        # Create DataFrame
        df = pd.DataFrame(all_features)
        
        # Replace NaN with None for SQL compatibility
        df = df.replace({np.nan: None})
        
        print(f"\nTotal records generated: {len(df)}")
        print(f"Failure rate: {df['faliure'].sum()} / {len(df)} ({100*df['faliure'].sum()/len(df):.2f}%)")
        
        # Clear existing data
        print("\nTruncating faliure_probability_base table...")
        cursor.execute("TRUNCATE TABLE faliure_probability_base")
        
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
                          if col in valid_columns and col not in ['asset_id', 'reading_date', 'faliure']]

        print("\nInserting data into faliure_probability_base...")
        
        # Insert data into database
        for idx, row in df.iterrows():
            # Build column list and values
            columns = ['asset_id', 'reading_date', 'faliure'] + feature_columns
            placeholders = ['%s'] * len(columns)
            values = [row['asset_id'], row['reading_date'], row['faliure']] + [row.get(col) for col in feature_columns]
            
            insert_sql = f"""
                INSERT INTO faliure_probability_base 
                ({', '.join(columns)})
                VALUES ({', '.join(placeholders)})
            """
            
            cursor.execute(insert_sql, values)
            
            if (idx + 1) % 100 == 0:
                print(f"  Inserted {idx + 1} / {len(df)} records...")
        
        connection.commit()
        print(f"\nSuccessfully saved {len(df)} asset-day feature vectors to faliure_probability_base table")
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
            print("Starting failure probability feature extraction ETL (daily granularity)...")
            
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
