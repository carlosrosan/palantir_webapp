-- SQL Script to insert sample data for Predictive Maintenance System
-- This script inserts coherent sample data respecting all foreign key relationships

USE palantir_maintenance;

-- Insert sample assets
INSERT INTO assets (asset_name, asset_type, location, installation_date, manufacturer, model_number, status) VALUES
('Compressor Unit A-101', 'Compressor', 'Building 1 - Floor 2', '2020-01-15', 'Atlas Copco', 'GA-75', 'operational'),
('Pump Station B-205', 'Pump', 'Building 2 - Basement', '2019-06-20', 'Grundfos', 'CR-32', 'operational'),
('Conveyor Belt C-301', 'Conveyor', 'Building 3 - Production Line 1', '2021-03-10', 'Siemens', 'SIMATIC', 'operational'),
('HVAC System D-401', 'HVAC', 'Building 4 - Roof', '2018-11-05', 'Carrier', '30XA-100', 'maintenance'),
('Generator E-501', 'Generator', 'Building 5 - Power Room', '2020-09-12', 'Cummins', 'QSK60', 'operational'),
('Motor F-601', 'Electric Motor', 'Building 6 - Assembly Line', '2021-07-22', 'ABB', 'M2BA-132', 'operational'),
('Boiler G-701', 'Boiler', 'Building 7 - Utility Room', '2019-02-28', 'Cleaver-Brooks', 'CB-200', 'operational'),
('Turbine H-801', 'Turbine', 'Building 8 - Power Plant', '2017-05-18', 'GE', '7FA', 'operational');

-- Insert sample maintenance employees
INSERT INTO mantainance_employees (first_name, last_name, email, phone, hire_date, department, position, salary) VALUES
('John', 'Smith', 'john.smith@company.com', '555-0101', '2018-03-15', 'Mechanical', 'Senior Technician', 65000.00),
('Maria', 'Garcia', 'maria.garcia@company.com', '555-0102', '2019-05-20', 'Electrical', 'Technician', 58000.00),
('David', 'Johnson', 'david.johnson@company.com', '555-0103', '2020-01-10', 'Mechanical', 'Technician', 55000.00),
('Sarah', 'Williams', 'sarah.williams@company.com', '555-0104', '2017-08-05', 'HVAC', 'Lead Technician', 72000.00),
('Michael', 'Brown', 'michael.brown@company.com', '555-0105', '2021-02-14', 'Electrical', 'Junior Technician', 48000.00),
('Emily', 'Davis', 'emily.davis@company.com', '555-0106', '2019-11-30', 'Mechanical', 'Technician', 57000.00),
('Robert', 'Miller', 'robert.miller@company.com', '555-0107', '2018-07-22', 'Power Systems', 'Senior Engineer', 85000.00),
('Lisa', 'Wilson', 'lisa.wilson@company.com', '555-0108', '2020-04-18', 'HVAC', 'Technician', 56000.00);

-- Insert sample education records for employees
INSERT INTO mantainance_employees_education (employee_id, degree, institution, graduation_year, field_of_study) VALUES
(1, 'Associate Degree', 'Technical College', 2016, 'Mechanical Engineering Technology'),
(1, 'Certificate', 'Industry Training Center', 2018, 'Advanced Compressor Maintenance'),
(2, 'Bachelor Degree', 'State University', 2018, 'Electrical Engineering'),
(2, 'Certificate', 'Electrical Safety Institute', 2019, 'Industrial Electrical Systems'),
(3, 'Associate Degree', 'Community College', 2019, 'Mechanical Technology'),
(4, 'Bachelor Degree', 'Engineering University', 2015, 'Mechanical Engineering'),
(4, 'Master Degree', 'Engineering University', 2017, 'HVAC Systems Design'),
(5, 'Associate Degree', 'Technical Institute', 2020, 'Electrical Technology'),
(6, 'Associate Degree', 'Vocational School', 2018, 'Industrial Maintenance'),
(7, 'Bachelor Degree', 'State University', 2015, 'Electrical Engineering'),
(7, 'Master Degree', 'State University', 2017, 'Power Systems Engineering'),
(8, 'Associate Degree', 'Technical College', 2019, 'HVAC Technology');

-- Insert sample asset values
INSERT INTO asset_value (asset_id, value_date, purchase_value, current_value, depreciation_rate, notes) VALUES
(1, '2020-01-15', 125000.00, 100000.00, 5.00, 'Initial purchase'),
(1, '2021-01-15', 125000.00, 95000.00, 5.00, 'Annual valuation'),
(1, '2022-01-15', 125000.00, 90000.00, 5.00, 'Annual valuation'),
(2, '2019-06-20', 45000.00, 32000.00, 6.00, 'Initial purchase'),
(2, '2020-06-20', 45000.00, 30000.00, 6.00, 'Annual valuation'),
(3, '2021-03-10', 85000.00, 75000.00, 4.00, 'Initial purchase'),
(3, '2022-03-10', 85000.00, 72000.00, 4.00, 'Annual valuation'),
(4, '2018-11-05', 180000.00, 120000.00, 7.00, 'Initial purchase'),
(4, '2019-11-05', 180000.00, 110000.00, 7.00, 'Annual valuation'),
(5, '2020-09-12', 250000.00, 210000.00, 4.50, 'Initial purchase'),
(5, '2021-09-12', 250000.00, 200000.00, 4.50, 'Annual valuation'),
(6, '2021-07-22', 12000.00, 11000.00, 3.00, 'Initial purchase'),
(7, '2019-02-28', 95000.00, 70000.00, 5.50, 'Initial purchase'),
(8, '2017-05-18', 500000.00, 350000.00, 6.00, 'Initial purchase');

-- Insert sample asset costs
INSERT INTO asset_costs (asset_id, cost_type, amount, cost_date, description, vendor, invoice_number) VALUES
(1, 'maintenance', 2500.00, '2022-01-20', 'Annual service and oil change', 'Atlas Copco Service', 'INV-2022-001'),
(1, 'repair', 8500.00, '2022-06-15', 'Replaced compressor head gasket', 'Industrial Parts Co', 'INV-2022-045'),
(2, 'maintenance', 1200.00, '2022-03-10', 'Quarterly maintenance check', 'Grundfos Service', 'INV-2022-012'),
(2, 'upgrade', 3500.00, '2022-08-22', 'Installed new control panel', 'Tech Solutions Inc', 'INV-2022-078'),
(3, 'maintenance', 1800.00, '2022-02-05', 'Belt replacement and alignment', 'Conveyor Systems Ltd', 'INV-2022-008'),
(4, 'repair', 12000.00, '2022-05-18', 'Replaced condenser unit', 'HVAC Specialists', 'INV-2022-034'),
(4, 'maintenance', 2200.00, '2022-11-01', 'Annual HVAC service', 'HVAC Specialists', 'INV-2022-092'),
(5, 'maintenance', 4500.00, '2022-04-12', 'Generator service and testing', 'Power Systems Co', 'INV-2022-023'),
(6, 'repair', 1500.00, '2022-09-30', 'Motor bearing replacement', 'Motor Repair Shop', 'INV-2022-081'),
(7, 'maintenance', 2800.00, '2022-07-15', 'Boiler inspection and cleaning', 'Boiler Services Inc', 'INV-2022-056'),
(8, 'maintenance', 15000.00, '2022-10-20', 'Turbine annual overhaul', 'GE Service', 'INV-2022-095');

-- Insert sample asset failures
INSERT INTO assets_faliures (asset_id, failure_date, failure_type, severity, description, root_cause, downtime_hours, resolved, resolution_date) VALUES
(1, '2022-06-10 14:30:00', 'Mechanical Failure', 'high', 'Compressor head gasket failure causing pressure loss', 'Wear and tear from continuous operation', 8.5, TRUE, '2022-06-15 18:00:00'),
(2, '2022-03-05 09:15:00', 'Electrical Failure', 'medium', 'Pump motor starter failure', 'Overheating due to poor ventilation', 4.0, TRUE, '2022-03-10 12:00:00'),
(3, '2022-01-28 16:45:00', 'Mechanical Failure', 'low', 'Conveyor belt misalignment', 'Loose mounting bolts', 2.5, TRUE, '2022-02-05 10:30:00'),
(4, '2022-05-15 11:20:00', 'Component Failure', 'critical', 'HVAC condenser unit complete failure', 'Corrosion and age-related wear', 24.0, TRUE, '2022-05-18 15:00:00'),
(5, '2022-08-10 07:00:00', 'Electrical Failure', 'medium', 'Generator voltage regulator malfunction', 'Faulty regulator component', 6.0, TRUE, '2022-08-12 14:00:00'),
(6, '2022-09-25 13:30:00', 'Bearing Failure', 'medium', 'Motor bearing overheating and failure', 'Lack of proper lubrication', 5.5, TRUE, '2022-09-30 17:00:00'),
(7, '2021-12-20 10:00:00', 'Pressure Failure', 'high', 'Boiler pressure relief valve failure', 'Valve stuck due to scale buildup', 12.0, TRUE, '2021-12-22 16:00:00'),
(8, '2022-10-15 08:30:00', 'Vibration Issue', 'medium', 'Excessive turbine vibration detected', 'Bearing wear requiring replacement', 0.0, FALSE, NULL);

-- Insert sample PLC sensor readings (200x more data per asset)
-- Using stored procedure to generate 200x more readings per asset
DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS generate_sensor_readings()
BEGIN
    DECLARE asset_id_var INT;
    DECLARE sensor_idx INT;
    DECLARE day_offset INT;
    DECLARE hour_offset INT;
    DECLARE minute_offset INT;
    DECLARE reading_val DECIMAL(10,2);
    DECLARE status_val VARCHAR(20);
    DECLARE sensor_config VARCHAR(255);
    DECLARE sensor_name_var VARCHAR(100);
    DECLARE sensor_type_var VARCHAR(50);
    DECLARE unit_var VARCHAR(20);
    DECLARE base_value DECIMAL(10,2);
    DECLARE timestamp_val DATETIME;
    
    -- Asset 1: Compressor (Temperature, Pressure, Vibration)
    SET asset_id_var = 1;
    SET sensor_idx = 0;
    WHILE sensor_idx < 600 DO  -- 200 readings per sensor type * 3 sensors
        SET day_offset = FLOOR(sensor_idx / 24);
        SET hour_offset = sensor_idx % 24;
        SET minute_offset = (sensor_idx * 15) % 60;
        SET timestamp_val = DATE_ADD('2022-10-01 00:00:00', INTERVAL day_offset DAY);
        SET timestamp_val = DATE_ADD(timestamp_val, INTERVAL hour_offset HOUR);
        SET timestamp_val = DATE_ADD(timestamp_val, INTERVAL minute_offset MINUTE);
        
        IF sensor_idx % 3 = 0 THEN
            SET sensor_name_var = 'Temperature Sensor 1';
            SET sensor_type_var = 'temperature';
            SET unit_var = 'Celsius';
            SET base_value = 75.0;
            SET reading_val = base_value + (RAND() * 15 - 5);
            SET status_val = IF(reading_val > 80, 'warning', IF(reading_val > 85, 'critical', 'normal'));
        ELSEIF sensor_idx % 3 = 1 THEN
            SET sensor_name_var = 'Pressure Sensor 1';
            SET sensor_type_var = 'pressure';
            SET unit_var = 'bar';
            SET base_value = 8.5;
            SET reading_val = base_value + (RAND() * 1.0 - 0.5);
            SET status_val = IF(reading_val < 7.5 OR reading_val > 9.5, 'warning', 'normal');
        ELSE
            SET sensor_name_var = 'Vibration Sensor 1';
            SET sensor_type_var = 'vibration';
            SET unit_var = 'mm/s';
            SET base_value = 2.3;
            SET reading_val = base_value + (RAND() * 2.0 - 1.0);
            SET status_val = IF(reading_val > 4.0, 'warning', IF(reading_val > 6.0, 'critical', 'normal'));
        END IF;
        
        INSERT INTO plc_sensor_readings (asset_id, sensor_name, sensor_type, reading_value, unit, reading_timestamp, status)
        VALUES (asset_id_var, sensor_name_var, sensor_type_var, reading_val, unit_var, timestamp_val, status_val);
        
        SET sensor_idx = sensor_idx + 1;
    END WHILE;
    
    -- Asset 2: Pump (Flow, Pressure, Temperature)
    SET asset_id_var = 2;
    SET sensor_idx = 0;
    WHILE sensor_idx < 600 DO
        SET day_offset = FLOOR(sensor_idx / 24);
        SET hour_offset = sensor_idx % 24;
        SET minute_offset = (sensor_idx * 15) % 60;
        SET timestamp_val = DATE_ADD('2022-10-01 00:00:00', INTERVAL day_offset DAY);
        SET timestamp_val = DATE_ADD(timestamp_val, INTERVAL hour_offset HOUR);
        SET timestamp_val = DATE_ADD(timestamp_val, INTERVAL minute_offset MINUTE);
        
        IF sensor_idx % 3 = 0 THEN
            SET sensor_name_var = 'Flow Sensor 1';
            SET sensor_type_var = 'flow';
            SET unit_var = 'L/min';
            SET base_value = 125.0;
            SET reading_val = base_value + (RAND() * 30 - 15);
            SET status_val = IF(reading_val < 100 OR reading_val > 150, 'warning', 'normal');
        ELSEIF sensor_idx % 3 = 1 THEN
            SET sensor_name_var = 'Pressure Sensor 1';
            SET sensor_type_var = 'pressure';
            SET unit_var = 'bar';
            SET base_value = 3.2;
            SET reading_val = base_value + (RAND() * 0.8 - 0.4);
            SET status_val = IF(reading_val < 2.5 OR reading_val > 4.0, 'warning', 'normal');
        ELSE
            SET sensor_name_var = 'Temperature Sensor 1';
            SET sensor_type_var = 'temperature';
            SET unit_var = 'Celsius';
            SET base_value = 45.0;
            SET reading_val = base_value + (RAND() * 10 - 5);
            SET status_val = IF(reading_val > 55, 'warning', 'normal');
        END IF;
        
        INSERT INTO plc_sensor_readings (asset_id, sensor_name, sensor_type, reading_value, unit, reading_timestamp, status)
        VALUES (asset_id_var, sensor_name_var, sensor_type_var, reading_val, unit_var, timestamp_val, status_val);
        
        SET sensor_idx = sensor_idx + 1;
    END WHILE;
    
    -- Asset 3: Conveyor (Speed, Load)
    SET asset_id_var = 3;
    SET sensor_idx = 0;
    WHILE sensor_idx < 400 DO  -- 200 readings per sensor type * 2 sensors
        SET day_offset = FLOOR(sensor_idx / 24);
        SET hour_offset = sensor_idx % 24;
        SET minute_offset = (sensor_idx * 15) % 60;
        SET timestamp_val = DATE_ADD('2022-10-01 00:00:00', INTERVAL day_offset DAY);
        SET timestamp_val = DATE_ADD(timestamp_val, INTERVAL hour_offset HOUR);
        SET timestamp_val = DATE_ADD(timestamp_val, INTERVAL minute_offset MINUTE);
        
        IF sensor_idx % 2 = 0 THEN
            SET sensor_name_var = 'Speed Sensor 1';
            SET sensor_type_var = 'speed';
            SET unit_var = 'm/s';
            SET base_value = 1.5;
            SET reading_val = base_value + (RAND() * 0.5 - 0.25);
            SET status_val = IF(reading_val < 1.0 OR reading_val > 2.0, 'warning', 'normal');
        ELSE
            SET sensor_name_var = 'Load Sensor 1';
            SET sensor_type_var = 'load';
            SET unit_var = 'kg';
            SET base_value = 850.0;
            SET reading_val = base_value + (RAND() * 200 - 100);
            SET status_val = IF(reading_val > 1000, 'warning', 'normal');
        END IF;
        
        INSERT INTO plc_sensor_readings (asset_id, sensor_name, sensor_type, reading_value, unit, reading_timestamp, status)
        VALUES (asset_id_var, sensor_name_var, sensor_type_var, reading_val, unit_var, timestamp_val, status_val);
        
        SET sensor_idx = sensor_idx + 1;
    END WHILE;
    
    -- Asset 4: HVAC (Temperature, Humidity, Pressure)
    SET asset_id_var = 4;
    SET sensor_idx = 0;
    WHILE sensor_idx < 600 DO
        SET day_offset = FLOOR(sensor_idx / 24);
        SET hour_offset = sensor_idx % 24;
        SET minute_offset = (sensor_idx * 15) % 60;
        SET timestamp_val = DATE_ADD('2022-10-01 00:00:00', INTERVAL day_offset DAY);
        SET timestamp_val = DATE_ADD(timestamp_val, INTERVAL hour_offset HOUR);
        SET timestamp_val = DATE_ADD(timestamp_val, INTERVAL minute_offset MINUTE);
        
        IF sensor_idx % 3 = 0 THEN
            SET sensor_name_var = 'Temperature Sensor 1';
            SET sensor_type_var = 'temperature';
            SET unit_var = 'Celsius';
            SET base_value = 22.5;
            SET reading_val = base_value + (RAND() * 5 - 2.5);
            SET status_val = IF(reading_val < 18 OR reading_val > 26, 'warning', 'normal');
        ELSEIF sensor_idx % 3 = 1 THEN
            SET sensor_name_var = 'Humidity Sensor 1';
            SET sensor_type_var = 'humidity';
            SET unit_var = '%';
            SET base_value = 45.0;
            SET reading_val = base_value + (RAND() * 20 - 10);
            SET status_val = IF(reading_val < 30 OR reading_val > 60, 'warning', 'normal');
        ELSE
            SET sensor_name_var = 'Pressure Sensor 1';
            SET sensor_type_var = 'pressure';
            SET unit_var = 'bar';
            SET base_value = 1.0;
            SET reading_val = base_value + (RAND() * 0.3 - 0.15);
            SET status_val = IF(reading_val < 0.7 OR reading_val > 1.3, 'warning', 'normal');
        END IF;
        
        INSERT INTO plc_sensor_readings (asset_id, sensor_name, sensor_type, reading_value, unit, reading_timestamp, status)
        VALUES (asset_id_var, sensor_name_var, sensor_type_var, reading_val, unit_var, timestamp_val, status_val);
        
        SET sensor_idx = sensor_idx + 1;
    END WHILE;
    
    -- Asset 5: Generator (Voltage, Current, Frequency)
    SET asset_id_var = 5;
    SET sensor_idx = 0;
    WHILE sensor_idx < 600 DO
        SET day_offset = FLOOR(sensor_idx / 24);
        SET hour_offset = sensor_idx % 24;
        SET minute_offset = (sensor_idx * 15) % 60;
        SET timestamp_val = DATE_ADD('2022-10-01 00:00:00', INTERVAL day_offset DAY);
        SET timestamp_val = DATE_ADD(timestamp_val, INTERVAL hour_offset HOUR);
        SET timestamp_val = DATE_ADD(timestamp_val, INTERVAL minute_offset MINUTE);
        
        IF sensor_idx % 3 = 0 THEN
            SET sensor_name_var = 'Voltage Sensor 1';
            SET sensor_type_var = 'voltage';
            SET unit_var = 'V';
            SET base_value = 480.0;
            SET reading_val = base_value + (RAND() * 20 - 10);
            SET status_val = IF(reading_val < 460 OR reading_val > 500, 'warning', 'normal');
        ELSEIF sensor_idx % 3 = 1 THEN
            SET sensor_name_var = 'Current Sensor 1';
            SET sensor_type_var = 'current';
            SET unit_var = 'A';
            SET base_value = 125.0;
            SET reading_val = base_value + (RAND() * 30 - 15);
            SET status_val = IF(reading_val > 150, 'warning', 'normal');
        ELSE
            SET sensor_name_var = 'Frequency Sensor 1';
            SET sensor_type_var = 'frequency';
            SET unit_var = 'Hz';
            SET base_value = 60.0;
            SET reading_val = base_value + (RAND() * 2 - 1);
            SET status_val = IF(reading_val < 58 OR reading_val > 62, 'warning', 'normal');
        END IF;
        
        INSERT INTO plc_sensor_readings (asset_id, sensor_name, sensor_type, reading_value, unit, reading_timestamp, status)
        VALUES (asset_id_var, sensor_name_var, sensor_type_var, reading_val, unit_var, timestamp_val, status_val);
        
        SET sensor_idx = sensor_idx + 1;
    END WHILE;
    
    -- Asset 6: Motor (Temperature, Vibration)
    SET asset_id_var = 6;
    SET sensor_idx = 0;
    WHILE sensor_idx < 400 DO
        SET day_offset = FLOOR(sensor_idx / 24);
        SET hour_offset = sensor_idx % 24;
        SET minute_offset = (sensor_idx * 15) % 60;
        SET timestamp_val = DATE_ADD('2022-10-01 00:00:00', INTERVAL day_offset DAY);
        SET timestamp_val = DATE_ADD(timestamp_val, INTERVAL hour_offset HOUR);
        SET timestamp_val = DATE_ADD(timestamp_val, INTERVAL minute_offset MINUTE);
        
        IF sensor_idx % 2 = 0 THEN
            SET sensor_name_var = 'Temperature Sensor 1';
            SET sensor_type_var = 'temperature';
            SET unit_var = 'Celsius';
            SET base_value = 65.0;
            SET reading_val = base_value + (RAND() * 15 - 7.5);
            SET status_val = IF(reading_val > 80, 'warning', IF(reading_val > 90, 'critical', 'normal'));
        ELSE
            SET sensor_name_var = 'Vibration Sensor 1';
            SET sensor_type_var = 'vibration';
            SET unit_var = 'mm/s';
            SET base_value = 1.8;
            SET reading_val = base_value + (RAND() * 1.5 - 0.75);
            SET status_val = IF(reading_val > 3.5, 'warning', IF(reading_val > 5.0, 'critical', 'normal'));
        END IF;
        
        INSERT INTO plc_sensor_readings (asset_id, sensor_name, sensor_type, reading_value, unit, reading_timestamp, status)
        VALUES (asset_id_var, sensor_name_var, sensor_type_var, reading_val, unit_var, timestamp_val, status_val);
        
        SET sensor_idx = sensor_idx + 1;
    END WHILE;
    
    -- Asset 7: Boiler (Temperature, Pressure)
    SET asset_id_var = 7;
    SET sensor_idx = 0;
    WHILE sensor_idx < 400 DO
        SET day_offset = FLOOR(sensor_idx / 24);
        SET hour_offset = sensor_idx % 24;
        SET minute_offset = (sensor_idx * 15) % 60;
        SET timestamp_val = DATE_ADD('2022-10-01 00:00:00', INTERVAL day_offset DAY);
        SET timestamp_val = DATE_ADD(timestamp_val, INTERVAL hour_offset HOUR);
        SET timestamp_val = DATE_ADD(timestamp_val, INTERVAL minute_offset MINUTE);
        
        IF sensor_idx % 2 = 0 THEN
            SET sensor_name_var = 'Temperature Sensor 1';
            SET sensor_type_var = 'temperature';
            SET unit_var = 'Celsius';
            SET base_value = 95.0;
            SET reading_val = base_value + (RAND() * 10 - 5);
            SET status_val = IF(reading_val > 105, 'warning', IF(reading_val > 110, 'critical', 'normal'));
        ELSE
            SET sensor_name_var = 'Pressure Sensor 1';
            SET sensor_type_var = 'pressure';
            SET unit_var = 'bar';
            SET base_value = 12.5;
            SET reading_val = base_value + (RAND() * 2.0 - 1.0);
            SET status_val = IF(reading_val < 10 OR reading_val > 15, 'warning', 'normal');
        END IF;
        
        INSERT INTO plc_sensor_readings (asset_id, sensor_name, sensor_type, reading_value, unit, reading_timestamp, status)
        VALUES (asset_id_var, sensor_name_var, sensor_type_var, reading_val, unit_var, timestamp_val, status_val);
        
        SET sensor_idx = sensor_idx + 1;
    END WHILE;
    
    -- Asset 8: Turbine (Vibration, Temperature, Pressure)
    SET asset_id_var = 8;
    SET sensor_idx = 0;
    WHILE sensor_idx < 600 DO
        SET day_offset = FLOOR(sensor_idx / 24);
        SET hour_offset = sensor_idx % 24;
        SET minute_offset = (sensor_idx * 15) % 60;
        SET timestamp_val = DATE_ADD('2022-10-01 00:00:00', INTERVAL day_offset DAY);
        SET timestamp_val = DATE_ADD(timestamp_val, INTERVAL hour_offset HOUR);
        SET timestamp_val = DATE_ADD(timestamp_val, INTERVAL minute_offset MINUTE);
        
        IF sensor_idx % 3 = 0 THEN
            SET sensor_name_var = 'Vibration Sensor 1';
            SET sensor_type_var = 'vibration';
            SET unit_var = 'mm/s';
            SET base_value = 4.2;
            SET reading_val = base_value + (RAND() * 3.0 - 1.5);
            SET status_val = IF(reading_val > 5.0, 'warning', IF(reading_val > 7.0, 'critical', 'normal'));
        ELSEIF sensor_idx % 3 = 1 THEN
            SET sensor_name_var = 'Temperature Sensor 1';
            SET sensor_type_var = 'temperature';
            SET unit_var = 'Celsius';
            SET base_value = 550.0;
            SET reading_val = base_value + (RAND() * 50 - 25);
            SET status_val = IF(reading_val > 600, 'warning', IF(reading_val > 650, 'critical', 'normal'));
        ELSE
            SET sensor_name_var = 'Pressure Sensor 1';
            SET sensor_type_var = 'pressure';
            SET unit_var = 'bar';
            SET base_value = 45.0;
            SET reading_val = base_value + (RAND() * 5.0 - 2.5);
            SET status_val = IF(reading_val < 40 OR reading_val > 50, 'warning', 'normal');
        END IF;
        
        INSERT INTO plc_sensor_readings (asset_id, sensor_name, sensor_type, reading_value, unit, reading_timestamp, status)
        VALUES (asset_id_var, sensor_name_var, sensor_type_var, reading_val, unit_var, timestamp_val, status_val);
        
        SET sensor_idx = sensor_idx + 1;
    END WHILE;
END$$

DELIMITER ;

CALL generate_sensor_readings();
DROP PROCEDURE IF EXISTS generate_sensor_readings;

-- Insert sample maintenance orders (200x more data per asset)
DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS generate_maintenance_orders()
BEGIN
    DECLARE asset_id_var INT;
    DECLARE order_idx INT;
    DECLARE employee_id_var INT;
    DECLARE order_type_var VARCHAR(20);
    DECLARE priority_var VARCHAR(20);
    DECLARE status_var VARCHAR(20);
    DECLARE scheduled_date_var DATETIME;
    DECLARE start_date_var DATETIME;
    DECLARE completion_date_var DATETIME;
    DECLARE estimated_cost_var DECIMAL(10,2);
    DECLARE actual_cost_var DECIMAL(10,2);
    DECLARE days_back INT;
    DECLARE order_id_var INT;
    
    -- Generate orders for each asset (200 orders per asset)
    SET asset_id_var = 1;
    WHILE asset_id_var <= 8 DO
        SET order_idx = 0;
        WHILE order_idx < 200 DO
            SET days_back = FLOOR(RAND() * 730);  -- Last 2 years
            SET scheduled_date_var = DATE_SUB('2022-11-20 08:00:00', INTERVAL days_back DAY);
            SET scheduled_date_var = DATE_ADD(scheduled_date_var, INTERVAL FLOOR(RAND() * 16) HOUR);
            
            -- Assign employee (1-8)
            SET employee_id_var = 1 + FLOOR(RAND() * 8);
            
            -- Determine order type (70% preventive, 20% corrective, 8% emergency, 2% upgrade)
            SET order_type_var = CASE
                WHEN RAND() < 0.70 THEN 'preventive'
                WHEN RAND() < 0.90 THEN 'corrective'
                WHEN RAND() < 0.98 THEN 'emergency'
                ELSE 'upgrade'
            END;
            
            -- Determine priority based on order type
            SET priority_var = CASE
                WHEN order_type_var = 'emergency' THEN 'urgent'
                WHEN order_type_var = 'corrective' AND RAND() < 0.5 THEN 'high'
                WHEN order_type_var = 'preventive' AND RAND() < 0.3 THEN 'high'
                WHEN order_type_var = 'preventive' AND RAND() < 0.7 THEN 'medium'
                ELSE 'low'
            END;
            
            -- Determine status (30% completed, 10% in_progress, 60% pending)
            SET status_var = CASE
                WHEN RAND() < 0.30 THEN 'completed'
                WHEN RAND() < 0.40 THEN 'in_progress'
                ELSE 'pending'
            END;
            
            -- Set dates based on status
            IF status_var = 'completed' THEN
                SET start_date_var = scheduled_date_var;
                SET completion_date_var = DATE_ADD(start_date_var, INTERVAL (1 + FLOOR(RAND() * 48)) HOUR);
                SET actual_cost_var = estimated_cost_var * (0.9 + RAND() * 0.2);  -- 90-110% of estimated
            ELSEIF status_var = 'in_progress' THEN
                SET start_date_var = scheduled_date_var;
                SET completion_date_var = NULL;
                SET actual_cost_var = NULL;
            ELSE
                SET start_date_var = NULL;
                SET completion_date_var = NULL;
                SET actual_cost_var = NULL;
            END IF;
            
            -- Set estimated cost based on asset and order type
            SET estimated_cost_var = CASE
                WHEN asset_id_var IN (5, 8) THEN 3000.00 + (RAND() * 12000.00)  -- Generator, Turbine
                WHEN asset_id_var IN (1, 4) THEN 2000.00 + (RAND() * 5000.00)    -- Compressor, HVAC
                WHEN asset_id_var IN (2, 3, 6, 7) THEN 500.00 + (RAND() * 3000.00)  -- Others
                ELSE 1000.00 + (RAND() * 2000.00)
            END;
            
            IF order_type_var = 'emergency' THEN
                SET estimated_cost_var = estimated_cost_var * 1.5;
            END IF;
            
            INSERT INTO mantainance_orders (asset_id, assigned_employee_id, order_type, priority, description, scheduled_date, start_date, completion_date, status, estimated_cost, actual_cost)
            VALUES (
                asset_id_var,
                employee_id_var,
                order_type_var,
                priority_var,
                CONCAT(order_type_var, ' maintenance for asset ', asset_id_var, ' - order ', order_idx + 1),
                scheduled_date_var,
                start_date_var,
                completion_date_var,
                status_var,
                estimated_cost_var,
                actual_cost_var
            );
            
            SET order_idx = order_idx + 1;
        END WHILE;
        
        SET asset_id_var = asset_id_var + 1;
    END WHILE;
END$$

DELIMITER ;

CALL generate_maintenance_orders();
DROP PROCEDURE IF EXISTS generate_maintenance_orders;

-- Insert sample maintenance tasks (200x more data - multiple tasks per order)
DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS generate_maintenance_tasks()
BEGIN
    DECLARE order_id_var INT;
    DECLARE task_idx INT;
    DECLARE tasks_per_order INT;
    DECLARE employee_id_var INT;
    DECLARE status_var VARCHAR(20);
    DECLARE estimated_hours_var DECIMAL(5,2);
    DECLARE actual_hours_var DECIMAL(5,2);
    DECLARE start_time_var DATETIME;
    DECLARE end_time_var DATETIME;
    DECLARE task_name_var VARCHAR(255);
    DECLARE task_desc_var VARCHAR(500);
    DECLARE order_scheduled_date DATETIME;
    DECLARE order_start_date DATETIME;
    DECLARE order_status VARCHAR(20);
    DECLARE max_order_id INT;
    DECLARE current_time_offset INT;
    
    -- Get the maximum order_id (all orders generated)
    SELECT MAX(order_id) INTO max_order_id FROM mantainance_orders;
    
    SET order_id_var = 1;
    WHILE order_id_var <= max_order_id DO
        -- Get order information
        SELECT scheduled_date, start_date, status 
        INTO order_scheduled_date, order_start_date, order_status
        FROM mantainance_orders 
        WHERE order_id = order_id_var;
        
        -- Generate 1-5 tasks per order (average 2.5 tasks per order = ~200x more)
        SET tasks_per_order = 1 + FLOOR(RAND() * 5);
        SET task_idx = 0;
        
        WHILE task_idx < tasks_per_order DO
            -- Assign employee (1-8)
            SET employee_id_var = 1 + FLOOR(RAND() * 8);
            
            -- Task names based on order type and task index
            SET task_name_var = CASE (task_idx % 10)
                WHEN 0 THEN 'Visual Inspection'
                WHEN 1 THEN 'Component Testing'
                WHEN 2 THEN 'Cleaning and Lubrication'
                WHEN 3 THEN 'Part Replacement'
                WHEN 4 THEN 'System Calibration'
                WHEN 5 THEN 'Performance Testing'
                WHEN 6 THEN 'Safety Check'
                WHEN 7 THEN 'Documentation Update'
                WHEN 8 THEN 'Diagnostic Analysis'
                ELSE 'Final Verification'
            END;
            
            SET task_desc_var = CONCAT(task_name_var, ' for order ', order_id_var, ' task ', task_idx + 1);
            
            -- Determine status based on order status
            IF order_status = 'completed' THEN
                SET status_var = CASE
                    WHEN RAND() < 0.9 THEN 'completed'
                    ELSE 'pending'
                END;
            ELSEIF order_status = 'in_progress' THEN
                SET status_var = CASE
                    WHEN RAND() < 0.4 THEN 'completed'
                    WHEN RAND() < 0.7 THEN 'in_progress'
                    ELSE 'pending'
                END;
            ELSE
                SET status_var = 'pending';
            END IF;
            
            -- Set estimated hours (0.5 to 8 hours)
            SET estimated_hours_var = 0.5 + (RAND() * 7.5);
            
            -- Set actual hours and times based on status
            IF status_var = 'completed' THEN
                SET actual_hours_var = estimated_hours_var * (0.8 + RAND() * 0.4);  -- 80-120% of estimated
                
                IF order_start_date IS NOT NULL THEN
                    SET current_time_offset = FLOOR(RAND() * 8);  -- Hours offset
                    SET start_time_var = DATE_ADD(order_start_date, INTERVAL current_time_offset HOUR);
                    SET end_time_var = DATE_ADD(start_time_var, INTERVAL FLOOR(actual_hours_var * 60) MINUTE);
                ELSE
                    SET start_time_var = DATE_ADD(order_scheduled_date, INTERVAL FLOOR(RAND() * 8) HOUR);
                    SET end_time_var = DATE_ADD(start_time_var, INTERVAL FLOOR(actual_hours_var * 60) MINUTE);
                END IF;
            ELSEIF status_var = 'in_progress' THEN
                SET actual_hours_var = NULL;
                IF order_start_date IS NOT NULL THEN
                    SET start_time_var = DATE_ADD(order_start_date, INTERVAL FLOOR(RAND() * 4) HOUR);
                ELSE
                    SET start_time_var = order_scheduled_date;
                END IF;
                SET end_time_var = NULL;
            ELSE
                SET actual_hours_var = NULL;
                SET start_time_var = NULL;
                SET end_time_var = NULL;
            END IF;
            
            INSERT INTO mantainance_tasks (order_id, task_name, task_description, assigned_employee_id, status, estimated_hours, actual_hours, start_time, end_time, notes)
            VALUES (
                order_id_var,
                task_name_var,
                task_desc_var,
                employee_id_var,
                status_var,
                estimated_hours_var,
                actual_hours_var,
                start_time_var,
                end_time_var,
                CASE 
                    WHEN status_var = 'completed' AND RAND() < 0.5 THEN 'Task completed successfully'
                    WHEN status_var = 'in_progress' THEN 'Work in progress'
                    ELSE NULL
                END
            );
            
            SET task_idx = task_idx + 1;
        END WHILE;
        
        SET order_id_var = order_id_var + 1;
    END WHILE;
END$$

DELIMITER ;

CALL generate_maintenance_tasks();
DROP PROCEDURE IF EXISTS generate_maintenance_tasks;

-- Insert sample failure probability data (calculated values)
INSERT INTO faliure_probability (asset_id, probability_score, risk_level, calculation_date, failure_count, warning_count, critical_sensor_count, days_since_maintenance, unresolved_failures, asset_age_days) VALUES
(1, 0.4500, 'medium', '2022-11-20 10:00:00', 1, 1, 0, 45, 0, 1040),
(2, 0.2500, 'low', '2022-11-20 10:00:00', 1, 0, 0, 5, 0, 1219),
(3, 0.2000, 'low', '2022-11-20 10:00:00', 1, 0, 0, 15, 0, 620),
(4, 0.6500, 'high', '2022-11-20 10:00:00', 1, 0, 0, 10, 0, 1476),
(5, 0.3000, 'medium', '2022-11-20 10:00:00', 1, 0, 0, 60, 0, 800),
(6, 0.2500, 'low', '2022-11-20 10:00:00', 1, 0, 0, 45, 0, 486),
(7, 0.3500, 'medium', '2022-11-20 10:00:00', 1, 0, 0, 90, 0, 1361),
(8, 0.5500, 'high', '2022-11-20 10:00:00', 1, 1, 0, 18, 1, 1982);

-- Insert sample maintenance cost data (calculated values)
INSERT INTO mantainace_cost (asset_id, calculation_date, total_cost, total_transactions, avg_cost_per_transaction, maintenance_cost, repair_cost, upgrade_cost, other_cost, cost_last_12m, cost_last_6m, cost_last_3m, transactions_12m, transactions_6m, transactions_3m, avg_monthly_cost, avg_yearly_cost, cost_per_day, cost_trend, last_cost_date, days_since_last_cost, asset_age_days) VALUES
(1, '2022-11-20 10:00:00', 11000.00, 2, 5500.00, 2500.00, 8500.00, 0.00, 0.00, 11000.00, 8500.00, 0.00, 2, 1, 0, 916.67, 11000.00, 10.58, 'increasing', '2022-06-15', 158, 1040),
(2, '2022-11-20 10:00:00', 4700.00, 2, 2350.00, 1200.00, 0.00, 3500.00, 0.00, 4700.00, 3500.00, 0.00, 2, 1, 0, 391.67, 4700.00, 3.85, 'stable', '2022-08-22', 90, 1219),
(3, '2022-11-20 10:00:00', 1800.00, 1, 1800.00, 1800.00, 0.00, 0.00, 0.00, 1800.00, 0.00, 0.00, 1, 0, 0, 150.00, 1800.00, 2.90, 'decreasing', '2022-02-05', 288, 620),
(4, '2022-11-20 10:00:00', 14200.00, 2, 7100.00, 2200.00, 12000.00, 0.00, 0.00, 14200.00, 14200.00, 2200.00, 2, 2, 1, 1183.33, 14200.00, 9.62, 'increasing', '2022-11-01', 19, 1476),
(5, '2022-11-20 10:00:00', 4500.00, 1, 4500.00, 4500.00, 0.00, 0.00, 0.00, 4500.00, 0.00, 0.00, 1, 0, 0, 375.00, 4500.00, 5.63, 'stable', '2022-04-12', 222, 800),
(6, '2022-11-20 10:00:00', 1500.00, 1, 1500.00, 0.00, 1500.00, 0.00, 0.00, 1500.00, 1500.00, 1500.00, 1, 1, 1, 125.00, 1500.00, 3.09, 'increasing', '2022-09-30', 51, 486),
(7, '2022-11-20 10:00:00', 2800.00, 1, 2800.00, 2800.00, 0.00, 0.00, 0.00, 2800.00, 2800.00, 0.00, 1, 1, 0, 233.33, 2800.00, 2.06, 'stable', '2022-07-15', 128, 1361),
(8, '2022-11-20 10:00:00', 15000.00, 1, 15000.00, 15000.00, 0.00, 0.00, 0.00, 15000.00, 15000.00, 15000.00, 1, 1, 1, 1250.00, 15000.00, 7.57, 'increasing', '2022-10-20', 31, 1982);

-- Insert sample failure probability base data (feature vectors)
INSERT INTO faliure_probability_base (asset_id, extraction_date, asset_age_days, asset_status, sensor_total_readings_30d, sensor_warning_count_30d, sensor_critical_count_30d, sensor_avg_normal_value, sensor_avg_warning_value, sensor_avg_critical_value, sensor_max_value, sensor_min_value, sensor_std_value, failure_count_365d, failure_critical_count, failure_high_count, failure_medium_count, failure_low_count, failure_avg_downtime, failure_total_downtime, failure_unresolved_count, days_since_last_failure, task_total_365d, task_completed_count, task_in_progress_count, task_pending_count, task_avg_estimated_hours, task_avg_actual_hours, task_total_hours, days_since_last_task, order_total_365d, order_preventive_count, order_corrective_count, order_emergency_count, order_completed_count, order_avg_estimated_cost, order_avg_actual_cost, order_total_actual_cost, days_since_last_order) VALUES
(1, '2022-11-20 10:00:00', 1040, 'operational', 4, 1, 0, 75.5, 82.0, NULL, 82.0, 75.5, 2.8, 1, 0, 1, 0, 0, 8.5, 8.5, 0, 163, 2, 0, 0, 2, 2.5, NULL, 0.0, NULL, 2, 1, 0, 1, 1, 3750.00, 5200.00, 11000.00, 0),
(2, '2022-11-20 10:00:00', 1219, 'operational', 3, 0, 0, 125.5, NULL, NULL, 125.5, 45.0, 40.2, 1, 0, 0, 1, 0, 4.0, 4.0, 0, 260, 2, 2, 0, 0, 1.25, 1.125, 2.25, 5, 2, 2, 0, 0, 2, 2350.00, 2300.00, 4700.00, 5),
(3, '2022-11-20 10:00:00', 620, 'operational', 2, 0, 0, 1.5, NULL, NULL, 1.5, 850.0, 600.0, 1, 0, 0, 0, 1, 2.5, 2.5, 0, 296, 2, 2, 0, 0, 2.0, 2.25, 4.5, 15, 1, 0, 1, 0, 1, 1800.00, 1750.00, 1800.00, 15),
(4, '2022-11-20 10:00:00', 1476, 'maintenance', 3, 0, 0, 22.5, NULL, NULL, 22.5, 1.0, 20.8, 1, 1, 0, 0, 0, 24.0, 24.0, 0, 189, 3, 1, 1, 1, 2.0, 1.0, 2.0, 10, 2, 1, 0, 0, 0, 2200.00, NULL, 14200.00, 10),
(5, '2022-11-20 10:00:00', 800, 'operational', 3, 0, 0, 480.0, NULL, NULL, 480.0, 60.0, 210.0, 1, 0, 0, 1, 0, 6.0, 6.0, 0, 102, 2, 0, 0, 2, 2.5, NULL, 0.0, NULL, 1, 1, 0, 0, 0, 4500.00, NULL, 4500.00, 60),
(6, '2022-11-20 10:00:00', 486, 'operational', 2, 0, 0, 65.0, NULL, NULL, 65.0, 1.8, 44.7, 1, 0, 0, 1, 0, 5.5, 5.5, 0, 56, 1, 1, 0, 0, 1.5, 2.0, 2.0, 45, 1, 0, 0, 0, 1, 500.00, 500.00, 1500.00, 45),
(7, '2022-11-20 10:00:00', 1361, 'operational', 2, 0, 0, 95.0, NULL, NULL, 95.0, 12.5, 58.4, 1, 0, 1, 0, 0, 12.0, 12.0, 0, 335, 2, 0, 0, 2, 3.0, NULL, 0.0, NULL, 1, 1, 0, 0, 0, 2800.00, NULL, 2800.00, 128),
(8, '2022-11-20 10:00:00', 1982, 'operational', 3, 1, 0, 550.0, 4.2, NULL, 550.0, 4.2, 315.0, 1, 0, 0, 1, 0, 0.0, 0.0, 1, 36, 2, 1, 1, 0, 7.5, 3.5, 3.5, 18, 1, 0, 1, 0, 0, 15000.00, NULL, 15000.00, 18);

-- Insert sample failure prediction data (LSTM predictions)
INSERT INTO faliure_prediction (asset_id, prediction_date, probability_score, predicted_failure, risk_level, model_version) VALUES
(1, '2022-11-20 10:00:00', 0.4523, FALSE, 'medium', 'LSTM_v1.0'),
(2, '2022-11-20 10:00:00', 0.2134, FALSE, 'low', 'LSTM_v1.0'),
(3, '2022-11-20 10:00:00', 0.1876, FALSE, 'low', 'LSTM_v1.0'),
(4, '2022-11-20 10:00:00', 0.7234, TRUE, 'critical', 'LSTM_v1.0'),
(5, '2022-11-20 10:00:00', 0.3456, FALSE, 'medium', 'LSTM_v1.0'),
(6, '2022-11-20 10:00:00', 0.2567, FALSE, 'low', 'LSTM_v1.0'),
(7, '2022-11-20 10:00:00', 0.3891, FALSE, 'medium', 'LSTM_v1.0'),
(8, '2022-11-20 10:00:00', 0.6123, TRUE, 'high', 'LSTM_v1.0');
