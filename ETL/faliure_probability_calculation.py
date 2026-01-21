"""
ETL Script for Failure Probability Calculation

This script calculates failure probability for each asset based on:
- Historical failure data
- Sensor readings (warnings/critical statuses)
- Asset age and maintenance history
- Recent maintenance activity

Output: Updates the faliure_probability table in MySQL
"""

import mysql.connector
from mysql.connector import Error
from datetime import datetime, timedelta
import os
from dotenv import load_dotenv
import sys

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


def calculate_failure_probability(asset_id, connection):
    """
    Calculate failure probability for a specific asset.
    
    Returns a probability score between 0 and 1.
    """
    cursor = connection.cursor(dictionary=True)
    
    try:
        # Get asset information
        cursor.execute("""
            SELECT asset_id, asset_name, asset_type, installation_date, status
            FROM assets
            WHERE asset_id = %s
        """, (asset_id,))
        asset = cursor.fetchone()
        
        if not asset:
            return None
        
        # Calculate asset age in days
        installation_date = asset['installation_date']
        age_days = (datetime.now().date() - installation_date).days
        
        # Factor 1: Historical failure rate (last 365 days)
        cursor.execute("""
            SELECT COUNT(*) as failure_count,
                   AVG(CASE 
                       WHEN severity = 'critical' THEN 1.0
                       WHEN severity = 'high' THEN 0.7
                       WHEN severity = 'medium' THEN 0.4
                       WHEN severity = 'low' THEN 0.2
                       ELSE 0.1
                   END) as avg_severity_score
            FROM assets_faliures
            WHERE asset_id = %s
            AND failure_date >= DATE_SUB(NOW(), INTERVAL 365 DAY)
        """, (asset_id,))
        failure_data = cursor.fetchone()
        failure_count = failure_data['failure_count'] or 0
        avg_severity = float(failure_data['avg_severity_score'] or 0)
        
        # Factor 2: Recent sensor warnings/critical readings (last 30 days)
        cursor.execute("""
            SELECT COUNT(*) as warning_count,
                   SUM(CASE WHEN status = 'critical' THEN 1 ELSE 0 END) as critical_count
            FROM plc_sensor_readings
            WHERE asset_id = %s
            AND reading_timestamp >= DATE_SUB(NOW(), INTERVAL 30 DAY)
            AND status IN ('warning', 'critical')
        """, (asset_id,))
        sensor_data = cursor.fetchone()
        warning_count = sensor_data['warning_count'] or 0
        critical_count = sensor_data['critical_count'] or 0
        
        # Factor 3: Time since last maintenance (preventive)
        cursor.execute("""
            SELECT MAX(completion_date) as last_maintenance
            FROM mantainance_orders
            WHERE asset_id = %s
            AND order_type = 'preventive'
            AND status = 'completed'
        """, (asset_id,))
        maintenance_data = cursor.fetchone()
        last_maintenance = maintenance_data['last_maintenance']
        
        days_since_maintenance = None
        if last_maintenance:
            days_since_maintenance = (datetime.now() - last_maintenance).days
        
        # Factor 4: Unresolved failures
        cursor.execute("""
            SELECT COUNT(*) as unresolved_count
            FROM assets_faliures
            WHERE asset_id = %s
            AND resolved = FALSE
        """, (asset_id,))
        unresolved_data = cursor.fetchone()
        unresolved_count = unresolved_data['unresolved_count'] or 0
        
        # Calculate probability components
        # Component 1: Historical failure rate (0-0.4 weight)
        failure_score = min(failure_count * 0.1 + avg_severity * 0.3, 0.4)
        
        # Component 2: Sensor warnings (0-0.3 weight)
        sensor_score = min(warning_count * 0.05 + critical_count * 0.15, 0.3)
        
        # Component 3: Maintenance gap (0-0.2 weight)
        maintenance_score = 0.0
        if days_since_maintenance is None:
            # No maintenance history - higher risk
            maintenance_score = 0.2
        elif days_since_maintenance > 180:
            maintenance_score = 0.2
        elif days_since_maintenance > 90:
            maintenance_score = 0.1
        else:
            maintenance_score = 0.0
        
        # Component 4: Unresolved failures (0-0.1 weight)
        unresolved_score = min(unresolved_count * 0.1, 0.1)
        
        # Base risk from age (older assets have slightly higher base risk)
        age_factor = min(age_days / 3650, 0.1)  # Max 0.1 for 10+ years
        
        # Total probability (0-1.0)
        total_probability = min(
            failure_score + sensor_score + maintenance_score + unresolved_score + age_factor,
            1.0
        )
        
        # Risk level classification
        if total_probability >= 0.7:
            risk_level = 'critical'
        elif total_probability >= 0.5:
            risk_level = 'high'
        elif total_probability >= 0.3:
            risk_level = 'medium'
        else:
            risk_level = 'low'
        
        return {
            'asset_id': asset_id,
            'probability_score': round(total_probability, 4),
            'risk_level': risk_level,
            'calculation_date': datetime.now(),
            'factors': {
                'failure_count': failure_count,
                'warning_count': warning_count,
                'critical_sensor_count': critical_count,
                'days_since_maintenance': days_since_maintenance,
                'unresolved_failures': unresolved_count,
                'asset_age_days': age_days
            }
        }
        
    finally:
        cursor.close()


def update_failure_probability_table(connection):
    """Update the failure_probability table with calculated values for all assets."""
    cursor = connection.cursor()
    
    try:
        # Get all assets
        cursor.execute("SELECT asset_id FROM assets")
        assets = cursor.fetchall()
        
        updated_count = 0
        
        for (asset_id,) in assets:
            result = calculate_failure_probability(asset_id, connection)
            
            if result:
                # Insert or update the failure probability record
                cursor.execute("""
                    INSERT INTO faliure_probability 
                    (asset_id, probability_score, risk_level, calculation_date, 
                     failure_count, warning_count, critical_sensor_count, 
                     days_since_maintenance, unresolved_failures, asset_age_days)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    ON DUPLICATE KEY UPDATE
                        probability_score = VALUES(probability_score),
                        risk_level = VALUES(risk_level),
                        calculation_date = VALUES(calculation_date),
                        failure_count = VALUES(failure_count),
                        warning_count = VALUES(warning_count),
                        critical_sensor_count = VALUES(critical_sensor_count),
                        days_since_maintenance = VALUES(days_since_maintenance),
                        unresolved_failures = VALUES(unresolved_failures),
                        asset_age_days = VALUES(asset_age_days),
                        updated_at = CURRENT_TIMESTAMP
                """, (
                    result['asset_id'],
                    result['probability_score'],
                    result['risk_level'],
                    result['calculation_date'],
                    result['factors']['failure_count'],
                    result['factors']['warning_count'],
                    result['factors']['critical_sensor_count'],
                    result['factors']['days_since_maintenance'],
                    result['factors']['unresolved_failures'],
                    result['factors']['asset_age_days']
                ))
                updated_count += 1
                print(f"Updated failure probability for asset_id {asset_id}: "
                      f"score={result['probability_score']:.4f}, "
                      f"risk={result['risk_level']}")
        
        connection.commit()
        print(f"\nSuccessfully updated {updated_count} asset failure probabilities")
        
    except Error as e:
        print(f"Error updating failure probability table: {e}")
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
            print("Starting failure probability calculation ETL...")
            
            update_failure_probability_table(connection)
            
            print("\nETL process completed successfully!")
            
    except Error as e:
        print(f"Database error: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {e}")
        sys.exit(1)
    finally:
        if connection and connection.is_connected():
            connection.close()
            print("MySQL connection closed")


if __name__ == "__main__":
    main()

