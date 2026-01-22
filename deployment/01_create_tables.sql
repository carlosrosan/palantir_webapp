-- SQL Script to create tables for Predictive Maintenance System
-- Database: palantir_maintenance

-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS palantir_maintenance;
USE palantir_maintenance;

-- Table: assets
CREATE TABLE IF NOT EXISTS palantir_maintenance.assets (
    asset_id INT AUTO_INCREMENT PRIMARY KEY,
    asset_name VARCHAR(255) NOT NULL,
    asset_type VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL,
    installation_date DATE NOT NULL,
    manufacturer VARCHAR(255),
    model_number VARCHAR(100),
    status VARCHAR(50) DEFAULT 'operational',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_asset_type (asset_type),
    INDEX idx_status (status),
    INDEX idx_location (location)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: mantainance_employees
CREATE TABLE IF NOT EXISTS palantir_maintenance.mantainance_employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    department VARCHAR(100) NOT NULL,
    position VARCHAR(100) NOT NULL,
    salary DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_department (department),
    INDEX idx_position (position)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: mantainance_employees_education
CREATE TABLE IF NOT EXISTS palantir_maintenance.mantainance_employees_education (
    education_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    degree VARCHAR(255) NOT NULL,
    institution VARCHAR(255) NOT NULL,
    graduation_year INT,
    field_of_study VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES mantainance_employees(employee_id) ON DELETE CASCADE,
    INDEX idx_employee_id (employee_id),
    INDEX idx_graduation_year (graduation_year)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: asset_value
CREATE TABLE IF NOT EXISTS palantir_maintenance.asset_value (
    value_id INT AUTO_INCREMENT PRIMARY KEY,
    asset_id INT NOT NULL,
    value_date DATE NOT NULL,
    purchase_value DECIMAL(12, 2) NOT NULL,
    current_value DECIMAL(12, 2) NOT NULL,
    depreciation_rate DECIMAL(5, 2),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE,
    INDEX idx_asset_id (asset_id),
    INDEX idx_value_date (value_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: asset_costs
CREATE TABLE IF NOT EXISTS palantir_maintenance.asset_costs (
    cost_id INT AUTO_INCREMENT PRIMARY KEY,
    asset_id INT NOT NULL,
    cost_type VARCHAR(100) NOT NULL,
    amount DECIMAL(12, 2) NOT NULL CHECK (amount >= 0),
    cost_date DATE NOT NULL,
    description TEXT,
    vendor VARCHAR(255),
    invoice_number VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE,
    INDEX idx_asset_id (asset_id),
    INDEX idx_cost_type (cost_type),
    INDEX idx_cost_date (cost_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: assets_faliures
CREATE TABLE IF NOT EXISTS palantir_maintenance.assets_faliures (
    failure_id INT AUTO_INCREMENT PRIMARY KEY,
    asset_id INT NOT NULL,
    failure_date DATETIME NOT NULL,
    failure_type VARCHAR(100) NOT NULL,
    severity VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    root_cause TEXT,
    downtime_hours DECIMAL(10, 2),
    resolved BOOLEAN DEFAULT FALSE,
    resolution_date DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE,
    INDEX idx_asset_id (asset_id),
    INDEX idx_failure_date (failure_date),
    INDEX idx_failure_type (failure_type),
    INDEX idx_severity (severity),
    INDEX idx_resolved (resolved)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: plc_sensor_readings
CREATE TABLE IF NOT EXISTS palantir_maintenance.plc_sensor_readings (
    reading_id INT AUTO_INCREMENT PRIMARY KEY,
    asset_id INT NOT NULL,
    sensor_name VARCHAR(255) NOT NULL,
    sensor_type VARCHAR(100) NOT NULL,
    reading_value DECIMAL(10, 4) NOT NULL,
    unit VARCHAR(50) NOT NULL,
    reading_timestamp DATETIME NOT NULL,
    status VARCHAR(50) DEFAULT 'normal',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE,
    INDEX idx_asset_id (asset_id),
    INDEX idx_reading_timestamp (reading_timestamp),
    INDEX idx_sensor_type (sensor_type),
    INDEX idx_status (status),
    INDEX idx_asset_timestamp (asset_id, reading_timestamp)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: mantainance_orders
CREATE TABLE IF NOT EXISTS palantir_maintenance.mantainance_orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    asset_id INT NOT NULL,
    assigned_employee_id INT,
    order_type VARCHAR(100) NOT NULL,
    priority VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    scheduled_date DATETIME,
    start_date DATETIME,
    completion_date DATETIME,
    status VARCHAR(50) DEFAULT 'pending',
    estimated_cost DECIMAL(12, 2),
    actual_cost DECIMAL(12, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_employee_id) REFERENCES mantainance_employees(employee_id) ON DELETE SET NULL,
    INDEX idx_asset_id (asset_id),
    INDEX idx_assigned_employee_id (assigned_employee_id),
    INDEX idx_order_type (order_type),
    INDEX idx_priority (priority),
    INDEX idx_status (status),
    INDEX idx_scheduled_date (scheduled_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: mantainance_tasks
CREATE TABLE IF NOT EXISTS palantir_maintenance.mantainance_tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    task_name VARCHAR(255) NOT NULL,
    task_description TEXT,
    assigned_employee_id INT,
    status VARCHAR(50) DEFAULT 'pending',
    estimated_hours DECIMAL(6, 2),
    actual_hours DECIMAL(6, 2),
    start_time DATETIME,
    end_time DATETIME,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES mantainance_orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_employee_id) REFERENCES mantainance_employees(employee_id) ON DELETE SET NULL,
    INDEX idx_order_id (order_id),
    INDEX idx_assigned_employee_id (assigned_employee_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: faliure_probability
CREATE TABLE IF NOT EXISTS palantir_maintenance.faliure_probability (
    probability_id INT AUTO_INCREMENT PRIMARY KEY,
    asset_id INT NOT NULL,
    probability_score DECIMAL(5, 4) NOT NULL CHECK (probability_score >= 0 AND probability_score <= 1),
    risk_level VARCHAR(50) NOT NULL,
    calculation_date DATETIME NOT NULL,
    failure_count INT DEFAULT 0,
    warning_count INT DEFAULT 0,
    critical_sensor_count INT DEFAULT 0,
    days_since_maintenance INT,
    unresolved_failures INT DEFAULT 0,
    asset_age_days INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE,
    UNIQUE KEY unique_asset_probability (asset_id),
    INDEX idx_asset_id (asset_id),
    INDEX idx_risk_level (risk_level),
    INDEX idx_probability_score (probability_score),
    INDEX idx_calculation_date (calculation_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: mantainace_cost
CREATE TABLE IF NOT EXISTS palantir_maintenance.mantainace_cost (
    cost_calculation_id INT AUTO_INCREMENT PRIMARY KEY,
    asset_id INT NOT NULL,
    calculation_date DATETIME NOT NULL,
    total_cost DECIMAL(12, 2) DEFAULT 0.00,
    total_transactions INT DEFAULT 0,
    avg_cost_per_transaction DECIMAL(12, 2) DEFAULT 0.00,
    maintenance_cost DECIMAL(12, 2) DEFAULT 0.00,
    repair_cost DECIMAL(12, 2) DEFAULT 0.00,
    upgrade_cost DECIMAL(12, 2) DEFAULT 0.00,
    other_cost DECIMAL(12, 2) DEFAULT 0.00,
    cost_last_12m DECIMAL(12, 2) DEFAULT 0.00,
    cost_last_6m DECIMAL(12, 2) DEFAULT 0.00,
    cost_last_3m DECIMAL(12, 2) DEFAULT 0.00,
    transactions_12m INT DEFAULT 0,
    transactions_6m INT DEFAULT 0,
    transactions_3m INT DEFAULT 0,
    avg_monthly_cost DECIMAL(12, 2) DEFAULT 0.00,
    avg_yearly_cost DECIMAL(12, 2) DEFAULT 0.00,
    cost_per_day DECIMAL(10, 4) DEFAULT 0.0000,
    cost_trend VARCHAR(50) DEFAULT 'stable',
    last_cost_date DATE,
    days_since_last_cost INT,
    asset_age_days INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE,
    UNIQUE KEY unique_asset_cost (asset_id),
    INDEX idx_asset_id (asset_id),
    INDEX idx_calculation_date (calculation_date),
    INDEX idx_cost_trend (cost_trend),
    INDEX idx_total_cost (total_cost)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: faliure_probability_base
CREATE TABLE IF NOT EXISTS palantir_maintenance.faliure_probability_base (
    base_id INT AUTO_INCREMENT PRIMARY KEY,
    asset_id INT NOT NULL,
    extraction_date DATETIME NOT NULL,
    -- Asset basic info
    asset_age_days INT,
    asset_status VARCHAR(50),
    -- Sensor features (last 30 days)
    sensor_total_readings_30d INT DEFAULT 0,
    sensor_warning_count_30d INT DEFAULT 0,
    sensor_critical_count_30d INT DEFAULT 0,
    sensor_avg_normal_value DECIMAL(12, 4),
    sensor_avg_warning_value DECIMAL(12, 4),
    sensor_avg_critical_value DECIMAL(12, 4),
    sensor_max_value DECIMAL(12, 4),
    sensor_min_value DECIMAL(12, 4),
    sensor_std_value DECIMAL(12, 4),
    -- Failure features (last 365 days)
    failure_count_365d INT DEFAULT 0,
    failure_critical_count INT DEFAULT 0,
    failure_high_count INT DEFAULT 0,
    failure_medium_count INT DEFAULT 0,
    failure_low_count INT DEFAULT 0,
    failure_avg_downtime DECIMAL(10, 2),
    failure_total_downtime DECIMAL(10, 2),
    failure_unresolved_count INT DEFAULT 0,
    days_since_last_failure INT,
    -- Maintenance task features (last 365 days)
    task_total_365d INT DEFAULT 0,
    task_completed_count INT DEFAULT 0,
    task_in_progress_count INT DEFAULT 0,
    task_pending_count INT DEFAULT 0,
    task_avg_estimated_hours DECIMAL(8, 2),
    task_avg_actual_hours DECIMAL(8, 2),
    task_total_hours DECIMAL(10, 2),
    days_since_last_task INT,
    -- Maintenance order features (last 365 days)
    order_total_365d INT DEFAULT 0,
    order_preventive_count INT DEFAULT 0,
    order_corrective_count INT DEFAULT 0,
    order_emergency_count INT DEFAULT 0,
    order_completed_count INT DEFAULT 0,
    order_avg_estimated_cost DECIMAL(12, 2),
    order_avg_actual_cost DECIMAL(12, 2),
    order_total_actual_cost DECIMAL(12, 2),
    days_since_last_order INT,
    -- Dynamic sensor type features (stored as JSON or additional columns)
    -- These will be added dynamically based on sensor types in the data
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE,
    UNIQUE KEY unique_asset_extraction (asset_id, extraction_date),
    INDEX idx_asset_id (asset_id),
    INDEX idx_extraction_date (extraction_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: faliure_prediction
CREATE TABLE IF NOT EXISTS palantir_maintenance.faliure_prediction (
    prediction_id INT AUTO_INCREMENT PRIMARY KEY,
    asset_id INT NOT NULL,
    prediction_date DATETIME NOT NULL,
    probability_score DECIMAL(5, 4) NOT NULL CHECK (probability_score >= 0 AND probability_score <= 1),
    predicted_failure BOOLEAN DEFAULT FALSE,
    risk_level VARCHAR(50) NOT NULL,
    model_version VARCHAR(50) DEFAULT 'LSTM_v1.0',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE,
    UNIQUE KEY unique_asset_prediction (asset_id, prediction_date),
    INDEX idx_asset_id (asset_id),
    INDEX idx_prediction_date (prediction_date),
    INDEX idx_risk_level (risk_level),
    INDEX idx_probability_score (probability_score),
    INDEX idx_predicted_failure (predicted_failure)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
