# Predictive Maintenance Web Application

A Django-based web application for predictive maintenance management with MySQL database integration.

## Features

- Asset management and tracking
- PLC sensor readings monitoring
- Failure tracking and analysis
- Maintenance order and task management
- Employee management and education tracking
- Asset value and cost tracking

## Database Tables

- `assets` - Physical assets requiring maintenance
- `plc_sensor_readings` - Sensor data from PLC systems
- `assets_faliures` - Failure records
- `asset_value` - Asset valuation over time
- `mantainance_employees` - Maintenance staff
- `asset_costs` - Cost tracking for assets
- `mantainance_employees_education` - Employee education records
- `mantainance_orders` - Maintenance work orders
- `mantainance_tasks` - Individual tasks within orders

## Setup Instructions

### Prerequisites

- Python 3.8 or higher
- MySQL 5.7 or higher
- pip (Python package manager)

### Installation

1. Install Python dependencies:
```bash
pip install -r requirements.txt
```

2. Create MySQL database:
```bash
mysql -u root -p < deployment/01_create_tables.sql
```

3. Load sample data (optional):
```bash
mysql -u root -p < deployment/02_insert_sample_data.sql
```

4. Update database settings in `palantir_webapp/settings.py`:
   - Update `NAME`, `USER`, `PASSWORD`, `HOST`, and `PORT` as needed

5. Run migrations:
```bash
python manage.py makemigrations
python manage.py migrate
```

6. Create superuser (optional):
```bash
python manage.py createsuperuser
```

7. Run development server:
```bash
python manage.py runserver
```

The application will be available at `http://127.0.0.1:8000/`

## Database Configuration

The default database configuration in `settings.py`:
- Database: `palantir_maintenance`
- User: `root`
- Password: (empty)
- Host: `localhost`
- Port: `3306`

Update these values in `palantir_webapp/settings.py` to match your MySQL setup.

## Deployment SQL Scripts

The `deployment` folder contains:
- `01_create_tables.sql` - Creates all database tables with proper relationships
- `02_insert_sample_data.sql` - Inserts sample data for testing

## Project Structure

```
.
├── manage.py
├── requirements.txt
├── palantir_webapp/
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   ├── wsgi.py
│   └── asgi.py
├── maintenance/
│   ├── __init__.py
│   ├── apps.py
│   ├── models.py
│   ├── admin.py
│   ├── views.py
│   └── urls.py
└── deployment/
    ├── 01_create_tables.sql
    └── 02_insert_sample_data.sql
```

## Admin Interface

Access the Django admin interface at `http://127.0.0.1:8000/admin/` after creating a superuser.

