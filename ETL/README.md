# ETL Scripts for Predictive Maintenance System

This directory contains ETL (Extract, Transform, Load) scripts that calculate and update maintenance metrics in the database.

## Scripts

### 1. `faliure_probability_calculation.py`

Calculates failure probability for each asset based on:
- Historical failure data (last 365 days)
- Recent sensor warnings/critical readings (last 30 days)
- Time since last maintenance
- Unresolved failures
- Asset age

**Output:** Updates the `faliure_probability` table

**Usage:**
```bash
python ETL/faliure_probability_calculation.py
```

### 2. `mantainance_cost_calculation.py`

Calculates maintenance cost metrics for each asset including:
- Total cost (all time)
- Costs by type (maintenance, repair, upgrade, other)
- Costs for last 12, 6, and 3 months
- Average monthly and yearly costs
- Cost per day
- Cost trend analysis

**Output:** Updates the `mantainace_cost` table

**Usage:**
```bash
python ETL/mantainance_cost_calculation.py
```

## Configuration

The scripts use environment variables for database configuration. Create a `.env` file in the project root:

```env
DB_HOST=localhost
DB_NAME=palantir_maintenance
DB_USER=root
DB_PASSWORD=your_password
DB_PORT=3306
```

If no `.env` file is provided, the scripts will use default values:
- Host: localhost
- Database: palantir_maintenance
- User: root
- Password: (empty)
- Port: 3306

## Dependencies

Install required packages:
```bash
pip install mysql-connector-python python-dotenv
```

Or install all requirements:
```bash
pip install -r requirements.txt
```

## Running ETL Scripts

It's recommended to run these scripts on a schedule (e.g., daily or weekly) to keep the calculated metrics up to date:

```bash
# Run failure probability calculation
python ETL/faliure_probability_calculation.py

# Run maintenance cost calculation
python ETL/mantainance_cost_calculation.py
```

## Notes

- The scripts use `INSERT ... ON DUPLICATE KEY UPDATE` to update existing records or create new ones
- Each script processes all assets in the database
- The scripts are idempotent - safe to run multiple times

