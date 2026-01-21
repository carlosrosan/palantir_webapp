"""
ETL Script for Maintenance Cost Calculation

This script calculates maintenance costs for each asset based on:
- Historical cost data (maintenance, repair, upgrade costs)
- Cost trends over time
- Total cost of ownership
- Average monthly/yearly costs

Output: Updates the mantainace_cost table in MySQL
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


def calculate_maintenance_costs(asset_id, connection):
    """
    Calculate maintenance costs for a specific asset.
    
    Returns a dictionary with various cost metrics.
    """
    cursor = connection.cursor(dictionary=True)
    
    try:
        # Get asset information
        cursor.execute("""
            SELECT asset_id, asset_name, asset_type, installation_date
            FROM assets
            WHERE asset_id = %s
        """, (asset_id,))
        asset = cursor.fetchone()
        
        if not asset:
            return None
        
        installation_date = asset['installation_date']
        asset_age_days = (datetime.now().date() - installation_date).days
        asset_age_years = asset_age_days / 365.0
        
        # Total costs (all time)
        cursor.execute("""
            SELECT 
                SUM(amount) as total_cost,
                COUNT(*) as total_transactions,
                AVG(amount) as avg_cost_per_transaction
            FROM asset_costs
            WHERE asset_id = %s
        """, (asset_id,))
        total_costs = cursor.fetchone()
        
        total_cost = float(total_costs['total_cost'] or 0)
        total_transactions = total_costs['total_transactions'] or 0
        avg_cost_per_transaction = float(total_costs['avg_cost_per_transaction'] or 0)
        
        # Costs by type
        cursor.execute("""
            SELECT 
                cost_type,
                SUM(amount) as type_total,
                COUNT(*) as type_count
            FROM asset_costs
            WHERE asset_id = %s
            GROUP BY cost_type
        """, (asset_id,))
        costs_by_type = cursor.fetchall()
        
        maintenance_cost = 0.0
        repair_cost = 0.0
        upgrade_cost = 0.0
        other_cost = 0.0
        
        for cost_type_data in costs_by_type:
            cost_type = cost_type_data['cost_type']
            type_total = float(cost_type_data['type_total'] or 0)
            
            if cost_type == 'maintenance':
                maintenance_cost = type_total
            elif cost_type == 'repair':
                repair_cost = type_total
            elif cost_type == 'upgrade':
                upgrade_cost = type_total
            else:
                other_cost += type_total
        
        # Costs in last 12 months
        cursor.execute("""
            SELECT 
                SUM(amount) as cost_12m,
                COUNT(*) as transactions_12m
            FROM asset_costs
            WHERE asset_id = %s
            AND cost_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
        """, (asset_id,))
        costs_12m = cursor.fetchone()
        
        cost_last_12m = float(costs_12m['cost_12m'] or 0)
        transactions_12m = costs_12m['transactions_12m'] or 0
        
        # Costs in last 6 months
        cursor.execute("""
            SELECT 
                SUM(amount) as cost_6m,
                COUNT(*) as transactions_6m
            FROM asset_costs
            WHERE asset_id = %s
            AND cost_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
        """, (asset_id,))
        costs_6m = cursor.fetchone()
        
        cost_last_6m = float(costs_6m['cost_6m'] or 0)
        transactions_6m = costs_6m['transactions_6m'] or 0
        
        # Costs in last 3 months
        cursor.execute("""
            SELECT 
                SUM(amount) as cost_3m,
                COUNT(*) as transactions_3m
            FROM asset_costs
            WHERE asset_id = %s
            AND cost_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
        """, (asset_id,))
        costs_3m = cursor.fetchone()
        
        cost_last_3m = float(costs_3m['cost_3m'] or 0)
        transactions_3m = costs_3m['transactions_3m'] or 0
        
        # Average monthly cost (based on last 12 months)
        avg_monthly_cost = cost_last_12m / 12.0 if cost_last_12m > 0 else 0.0
        
        # Average yearly cost (based on asset age)
        avg_yearly_cost = total_cost / asset_age_years if asset_age_years > 0 else 0.0
        
        # Cost per day of operation
        cost_per_day = total_cost / asset_age_days if asset_age_days > 0 else 0.0
        
        # Cost trend (comparing last 6 months to previous 6 months)
        cursor.execute("""
            SELECT 
                SUM(amount) as cost_prev_6m
            FROM asset_costs
            WHERE asset_id = %s
            AND cost_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
            AND cost_date < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
        """, (asset_id,))
        prev_6m = cursor.fetchone()
        cost_prev_6m = float(prev_6m['cost_prev_6m'] or 0)
        
        cost_trend = 'stable'
        if cost_prev_6m > 0:
            trend_percentage = ((cost_last_6m - cost_prev_6m) / cost_prev_6m) * 100
            if trend_percentage > 20:
                cost_trend = 'increasing'
            elif trend_percentage < -20:
                cost_trend = 'decreasing'
        elif cost_last_6m > 0:
            cost_trend = 'increasing'
        
        # Last cost date
        cursor.execute("""
            SELECT MAX(cost_date) as last_cost_date
            FROM asset_costs
            WHERE asset_id = %s
        """, (asset_id,))
        last_cost = cursor.fetchone()
        last_cost_date = last_cost['last_cost_date']
        
        days_since_last_cost = None
        if last_cost_date:
            days_since_last_cost = (datetime.now().date() - last_cost_date).days
        
        return {
            'asset_id': asset_id,
            'calculation_date': datetime.now(),
            'total_cost': round(total_cost, 2),
            'total_transactions': total_transactions,
            'avg_cost_per_transaction': round(avg_cost_per_transaction, 2),
            'maintenance_cost': round(maintenance_cost, 2),
            'repair_cost': round(repair_cost, 2),
            'upgrade_cost': round(upgrade_cost, 2),
            'other_cost': round(other_cost, 2),
            'cost_last_12m': round(cost_last_12m, 2),
            'cost_last_6m': round(cost_last_6m, 2),
            'cost_last_3m': round(cost_last_3m, 2),
            'transactions_12m': transactions_12m,
            'transactions_6m': transactions_6m,
            'transactions_3m': transactions_3m,
            'avg_monthly_cost': round(avg_monthly_cost, 2),
            'avg_yearly_cost': round(avg_yearly_cost, 2),
            'cost_per_day': round(cost_per_day, 4),
            'cost_trend': cost_trend,
            'last_cost_date': last_cost_date,
            'days_since_last_cost': days_since_last_cost,
            'asset_age_days': asset_age_days
        }
        
    finally:
        cursor.close()


def update_maintenance_cost_table(connection):
    """Update the mantainace_cost table with calculated values for all assets."""
    cursor = connection.cursor()
    
    try:
        # Get all assets
        cursor.execute("SELECT asset_id FROM assets")
        assets = cursor.fetchall()
        
        updated_count = 0
        
        for (asset_id,) in assets:
            result = calculate_maintenance_costs(asset_id, connection)
            
            if result:
                # Insert or update the maintenance cost record
                cursor.execute("""
                    INSERT INTO mantainace_cost 
                    (asset_id, calculation_date, total_cost, total_transactions, 
                     avg_cost_per_transaction, maintenance_cost, repair_cost, 
                     upgrade_cost, other_cost, cost_last_12m, cost_last_6m, 
                     cost_last_3m, transactions_12m, transactions_6m, 
                     transactions_3m, avg_monthly_cost, avg_yearly_cost, 
                     cost_per_day, cost_trend, last_cost_date, 
                     days_since_last_cost, asset_age_days)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 
                            %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    ON DUPLICATE KEY UPDATE
                        calculation_date = VALUES(calculation_date),
                        total_cost = VALUES(total_cost),
                        total_transactions = VALUES(total_transactions),
                        avg_cost_per_transaction = VALUES(avg_cost_per_transaction),
                        maintenance_cost = VALUES(maintenance_cost),
                        repair_cost = VALUES(repair_cost),
                        upgrade_cost = VALUES(upgrade_cost),
                        other_cost = VALUES(other_cost),
                        cost_last_12m = VALUES(cost_last_12m),
                        cost_last_6m = VALUES(cost_last_6m),
                        cost_last_3m = VALUES(cost_last_3m),
                        transactions_12m = VALUES(transactions_12m),
                        transactions_6m = VALUES(transactions_6m),
                        transactions_3m = VALUES(transactions_3m),
                        avg_monthly_cost = VALUES(avg_monthly_cost),
                        avg_yearly_cost = VALUES(avg_yearly_cost),
                        cost_per_day = VALUES(cost_per_day),
                        cost_trend = VALUES(cost_trend),
                        last_cost_date = VALUES(last_cost_date),
                        days_since_last_cost = VALUES(days_since_last_cost),
                        asset_age_days = VALUES(asset_age_days),
                        updated_at = CURRENT_TIMESTAMP
                """, (
                    result['asset_id'],
                    result['calculation_date'],
                    result['total_cost'],
                    result['total_transactions'],
                    result['avg_cost_per_transaction'],
                    result['maintenance_cost'],
                    result['repair_cost'],
                    result['upgrade_cost'],
                    result['other_cost'],
                    result['cost_last_12m'],
                    result['cost_last_6m'],
                    result['cost_last_3m'],
                    result['transactions_12m'],
                    result['transactions_6m'],
                    result['transactions_3m'],
                    result['avg_monthly_cost'],
                    result['avg_yearly_cost'],
                    result['cost_per_day'],
                    result['cost_trend'],
                    result['last_cost_date'],
                    result['days_since_last_cost'],
                    result['asset_age_days']
                ))
                updated_count += 1
                print(f"Updated maintenance cost for asset_id {asset_id}: "
                      f"total=${result['total_cost']:.2f}, "
                      f"12m=${result['cost_last_12m']:.2f}, "
                      f"trend={result['cost_trend']}")
        
        connection.commit()
        print(f"\nSuccessfully updated {updated_count} asset maintenance costs")
        
    except Error as e:
        print(f"Error updating maintenance cost table: {e}")
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
            print("Starting maintenance cost calculation ETL...")
            
            update_maintenance_cost_table(connection)
            
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

