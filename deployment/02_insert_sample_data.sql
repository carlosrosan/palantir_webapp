-- SQL Script to insert sample data for Predictive Maintenance System
-- Industrial predictive maintenance: hydraulic pumps and electric motors only.
-- Failures: ball bearing, motor overload (motors), cavitation (pumps). 3 failures per asset per year of sensor data.
-- Sensor data: mechanical vibration, RPM, power, current, pressure, flow. Orders: visual inspections.

USE palantir_maintenance;

-- Insert sample assets: hydraulic pumps and electric motors only
INSERT INTO assets (asset_name, asset_type, location, installation_date, manufacturer, model_number, status) VALUES
('Hydraulic Pump A-101', 'Hydraulic Pump', 'Building 1 - Floor 2', '2020-01-15', 'Grundfos', 'CR-32', 'operational'),
('Hydraulic Pump B-102', 'Hydraulic Pump', 'Building 2 - Basement', '2019-06-20', 'Parker', 'P1-45', 'operational'),
('Hydraulic Pump C-103', 'Hydraulic Pump', 'Building 3 - Production', '2021-03-10', 'Bosch Rexroth', 'A10VSO', 'operational'),
('Hydraulic Pump D-104', 'Hydraulic Pump', 'Building 4 - Fluid Room', '2018-11-05', 'Eaton', 'Vickers', 'maintenance'),
('Electric Motor E-201', 'Electric Motor', 'Building 5 - Assembly Line', '2020-09-12', 'ABB', 'M2BA-132', 'operational'),
('Electric Motor F-202', 'Electric Motor', 'Building 6 - Conveyor', '2021-07-22', 'Siemens', '1LE0', 'operational'),
('Electric Motor G-203', 'Electric Motor', 'Building 7 - Machine Shop', '2019-02-28', 'WEG', 'W22', 'operational'),
('Electric Motor H-204', 'Electric Motor', 'Building 8 - Packaging', '2017-05-18', 'Baldor', 'EM3767T', 'operational');

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

-- Insert sample asset values (pumps and motors)
INSERT INTO asset_value (asset_id, value_date, purchase_value, current_value, depreciation_rate, notes) VALUES
(1, '2020-01-15', 45000.00, 36000.00, 5.00, 'Initial purchase'),
(1, '2021-01-15', 45000.00, 34200.00, 5.00, 'Annual valuation'),
(2, '2019-06-20', 38000.00, 27000.00, 6.00, 'Initial purchase'),
(2, '2020-06-20', 38000.00, 25400.00, 6.00, 'Annual valuation'),
(3, '2021-03-10', 52000.00, 46800.00, 4.00, 'Initial purchase'),
(4, '2018-11-05', 48000.00, 32000.00, 7.00, 'Initial purchase'),
(5, '2020-09-12', 12000.00, 10200.00, 4.50, 'Initial purchase'),
(5, '2021-09-12', 12000.00, 9600.00, 4.50, 'Annual valuation'),
(6, '2021-07-22', 9500.00, 8800.00, 3.00, 'Initial purchase'),
(7, '2019-02-28', 11000.00, 8200.00, 5.50, 'Initial purchase'),
(8, '2017-05-18', 14000.00, 9800.00, 6.00, 'Initial purchase');

-- Insert sample asset costs (pumps and motors)
INSERT INTO asset_costs (asset_id, cost_type, amount, cost_date, description, vendor, invoice_number) VALUES
(1, 'maintenance', 800.00, '2022-01-20', 'Visual inspection and seal check', 'Grundfos Service', 'INV-2022-001'),
(1, 'repair', 2200.00, '2022-06-15', 'Ball bearing replacement', 'Industrial Parts Co', 'INV-2022-045'),
(2, 'maintenance', 600.00, '2022-03-10', 'Visual inspection', 'Parker Service', 'INV-2022-012'),
(3, 'repair', 1800.00, '2022-08-22', 'Cavitation damage repair', 'Bosch Rexroth', 'INV-2022-078'),
(4, 'maintenance', 700.00, '2022-11-01', 'Visual inspection', 'Eaton Service', 'INV-2022-092'),
(5, 'repair', 1500.00, '2022-09-30', 'Motor bearing replacement', 'ABB Service', 'INV-2022-081'),
(6, 'maintenance', 500.00, '2022-04-12', 'Visual inspection', 'Siemens Service', 'INV-2022-023'),
(7, 'repair', 3200.00, '2022-07-15', 'Winding burnout from overload', 'WEG Repair', 'INV-2022-056'),
(8, 'maintenance', 550.00, '2022-10-20', 'Visual inspection', 'Baldor Service', 'INV-2022-095');

-- Insert sample asset failures: 3 per asset per year (one per failure type). Sensor data year = 2022.
-- Pumps (1-4): Ball Bearing Failure, Cavitation. Motors (5-8): Ball Bearing Failure, Motor Overload/Burnout.
INSERT INTO assets_faliures (asset_id, failure_date, failure_type, severity, description, root_cause, downtime_hours, resolved, resolution_date) VALUES
-- Asset 1 Hydraulic Pump: 3 failures in 2022
(1, '2022-02-14 08:30:00', 'Ball Bearing Failure', 'medium', 'Pump ball bearing wear detected', 'Normal wear from continuous operation', 4.0, TRUE, '2022-02-14 12:30:00'),
(1, '2022-06-22 14:00:00', 'Cavitation', 'high', 'Cavitation damage to impeller', 'Low inlet pressure and NPSH', 8.0, TRUE, '2022-06-23 22:00:00'),
(1, '2022-11-03 06:45:00', 'Ball Bearing Failure', 'low', 'Ball bearing noise increase', 'Lubrication degradation', 2.5, TRUE, '2022-11-03 09:15:00'),
-- Asset 2 Hydraulic Pump
(2, '2022-03-08 09:00:00', 'Cavitation', 'medium', 'Cavitation pitting on casing', 'Air ingress in suction line', 5.0, TRUE, '2022-03-08 14:00:00'),
(2, '2022-07-18 11:20:00', 'Ball Bearing Failure', 'medium', 'Bearing cage failure', 'Contamination', 6.0, TRUE, '2022-07-18 17:20:00'),
(2, '2022-10-28 07:00:00', 'Cavitation', 'low', 'Minor cavitation noise', 'Temperature rise', 1.5, TRUE, '2022-10-28 08:30:00'),
-- Asset 3 Hydraulic Pump
(3, '2022-01-25 10:15:00', 'Ball Bearing Failure', 'high', 'Ball bearing seizure', 'Lack of lubrication', 12.0, TRUE, '2022-01-25 22:15:00'),
(3, '2022-05-12 16:30:00', 'Cavitation', 'medium', 'Cavitation erosion', 'High fluid temperature', 4.5, TRUE, '2022-05-12 21:00:00'),
(3, '2022-09-20 08:00:00', 'Ball Bearing Failure', 'medium', 'Inner race spalling', 'Fatigue', 5.5, TRUE, '2022-09-20 13:30:00'),
-- Asset 4 Hydraulic Pump
(4, '2022-04-05 07:45:00', 'Cavitation', 'critical', 'Severe cavitation damage', 'Blocked suction filter', 16.0, TRUE, '2022-04-06 23:45:00'),
(4, '2022-08-14 13:20:00', 'Ball Bearing Failure', 'medium', 'Bearing vibration spike', 'Wear', 3.0, TRUE, '2022-08-14 16:20:00'),
(4, '2022-12-01 09:30:00', 'Cavitation', 'low', 'Cavitation onset', 'Low flow operation', 2.0, TRUE, '2022-12-01 11:30:00'),
-- Asset 5 Electric Motor: 3 failures in 2022
(5, '2022-02-28 11:00:00', 'Ball Bearing Failure', 'medium', 'Motor ball bearing failure', 'Overload and heat', 5.0, TRUE, '2022-02-28 16:00:00'),
(5, '2022-06-10 08:15:00', 'Motor Overload', 'high', 'Winding burnout from overload', 'Sustained overload', 24.0, TRUE, '2022-06-11 08:15:00'),
(5, '2022-10-15 14:30:00', 'Ball Bearing Failure', 'low', 'Bearing grease degradation', 'High ambient temperature', 3.0, TRUE, '2022-10-15 17:30:00'),
-- Asset 6 Electric Motor
(6, '2022-03-18 06:00:00', 'Motor Overload', 'medium', 'Stator burnout', 'Electrical overload', 18.0, TRUE, '2022-03-18 00:00:00'),
(6, '2022-07-25 10:45:00', 'Ball Bearing Failure', 'high', 'Bearing inner race failure', 'Misalignment', 8.0, TRUE, '2022-07-25 18:45:00'),
(6, '2022-11-08 09:20:00', 'Motor Overload', 'low', 'Thermal overload trip', 'Blocked cooling', 2.0, TRUE, '2022-11-08 11:20:00'),
-- Asset 7 Electric Motor
(7, '2022-01-12 15:00:00', 'Ball Bearing Failure', 'critical', 'Bearing seizure', 'Lubrication failure', 14.0, TRUE, '2022-01-13 05:00:00'),
(7, '2022-05-30 07:30:00', 'Motor Overload', 'high', 'Winding insulation burnout', 'Overload', 20.0, TRUE, '2022-05-31 03:30:00'),
(7, '2022-09-05 12:00:00', 'Ball Bearing Failure', 'medium', 'Bearing outer race damage', 'Vibration', 4.5, TRUE, '2022-09-05 16:30:00'),
-- Asset 8 Electric Motor
(8, '2022-04-22 08:00:00', 'Motor Overload', 'medium', 'Rotor bar damage from overload', 'Starting overload', 10.0, TRUE, '2022-04-22 18:00:00'),
(8, '2022-08-08 11:30:00', 'Ball Bearing Failure', 'medium', 'Ball bearing wear', 'Normal wear', 5.0, TRUE, '2022-08-08 16:30:00'),
(8, '2022-12-12 06:45:00', 'Motor Overload', 'low', 'Overload relay trip', 'Peak load', 1.0, TRUE, '2022-12-12 07:45:00');

-- Insert PLC sensor readings: mechanical vibration, RPM, power, electrical current, pressure, flow (1 year = 2022)
DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS generate_sensor_readings()
BEGIN
    DECLARE asset_id_var INT DEFAULT 1;
    DECLARE day_offset INT DEFAULT 0;
    DECLARE hour_offset INT DEFAULT 0;
    DECLARE sens_ord INT DEFAULT 0;
    DECLARE reading_val DECIMAL(10,4);
    DECLARE status_val VARCHAR(20);
    DECLARE sensor_name_var VARCHAR(100);
    DECLARE sensor_type_var VARCHAR(50);
    DECLARE unit_var VARCHAR(20);
    DECLARE base_val DECIMAL(10,4);
    DECLARE timestamp_val DATETIME;
    DECLARE is_pump TINYINT;
    
    WHILE asset_id_var <= 8 DO
        SET is_pump = IF(asset_id_var <= 4, 1, 0);
        SET day_offset = 0;
        WHILE day_offset < 365 DO
            SET hour_offset = 0;
            WHILE hour_offset < 24 DO  -- 4 samples per day (0, 6, 12, 18 h)
                SET timestamp_val = DATE_ADD('2022-01-01 00:00:00', INTERVAL day_offset DAY);
                SET timestamp_val = DATE_ADD(timestamp_val, INTERVAL hour_offset HOUR);
                
                -- Vibration (mechanical vibration, mm/s)
                SET base_val = 1.5 + (asset_id_var * 0.2);
                SET reading_val = base_val + (RAND() * 1.5 - 0.75);
                SET status_val = IF(reading_val > 4.0, 'warning', IF(reading_val > 6.0, 'critical', 'normal'));
                INSERT INTO plc_sensor_readings (asset_id, sensor_name, sensor_type, reading_value, unit, reading_timestamp, status)
                VALUES (asset_id_var, 'Vibration Sensor', 'vibration', reading_val, 'mm/s', timestamp_val, status_val);
                
                -- RPM
                SET base_val = 1450.0 + (asset_id_var * 50) + (RAND() * 100 - 50);
                SET reading_val = base_val;
                SET status_val = IF(reading_val < 1200 OR reading_val > 1800, 'warning', 'normal');
                INSERT INTO plc_sensor_readings (asset_id, sensor_name, sensor_type, reading_value, unit, reading_timestamp, status)
                VALUES (asset_id_var, 'RPM Sensor', 'rpm', reading_val, 'rpm', timestamp_val, status_val);
                
                -- Power (kW)
                SET base_val = IF(is_pump, 15.0 + asset_id_var * 2, 11.0 + (asset_id_var - 4) * 1.5);
                SET reading_val = base_val + (RAND() * 4 - 2);
                SET status_val = IF(reading_val > base_val * 1.2, 'warning', 'normal');
                INSERT INTO plc_sensor_readings (asset_id, sensor_name, sensor_type, reading_value, unit, reading_timestamp, status)
                VALUES (asset_id_var, 'Power Sensor', 'power', reading_val, 'kW', timestamp_val, status_val);
                
                -- Electrical current (A) - drive motor for pumps, main for motors
                SET base_val = 22.0 + asset_id_var * 1.5 + (RAND() * 6 - 3);
                SET reading_val = base_val;
                SET status_val = IF(reading_val > 30, 'warning', IF(reading_val > 35, 'critical', 'normal'));
                INSERT INTO plc_sensor_readings (asset_id, sensor_name, sensor_type, reading_value, unit, reading_timestamp, status)
                VALUES (asset_id_var, 'Current Sensor', 'current', reading_val, 'A', timestamp_val, status_val);
                
                -- Pressure (bar) - pumps have discharge pressure; motors 0 or skip (we insert 0 for motors)
                IF is_pump = 1 THEN
                    SET base_val = 4.0 + (asset_id_var * 0.3) + (RAND() * 1.0 - 0.5);
                    SET reading_val = base_val;
                    SET status_val = IF(reading_val < 2.5 OR reading_val > 6.0, 'warning', 'normal');
                ELSE
                    SET reading_val = 0;
                    SET status_val = 'normal';
                END IF;
                INSERT INTO plc_sensor_readings (asset_id, sensor_name, sensor_type, reading_value, unit, reading_timestamp, status)
                VALUES (asset_id_var, 'Pressure Sensor', 'pressure', reading_val, 'bar', timestamp_val, status_val);
                
                -- Flow (L/min) - pumps only; motors 0
                IF is_pump = 1 THEN
                    SET base_val = 80.0 + (asset_id_var * 15) + (RAND() * 20 - 10);
                    SET reading_val = base_val;
                    SET status_val = IF(reading_val < 50 OR reading_val > 150, 'warning', 'normal');
                ELSE
                    SET reading_val = 0;
                    SET status_val = 'normal';
                END IF;
                INSERT INTO plc_sensor_readings (asset_id, sensor_name, sensor_type, reading_value, unit, reading_timestamp, status)
                VALUES (asset_id_var, 'Flow Sensor', 'flow', reading_val, 'L/min', timestamp_val, status_val);
                
                SET hour_offset = hour_offset + 6;
            END WHILE;
            SET day_offset = day_offset + 1;
        END WHILE;
        SET asset_id_var = asset_id_var + 1;
    END WHILE;
END$$

DELIMITER ;

CALL generate_sensor_readings();
DROP PROCEDURE IF EXISTS generate_sensor_readings;

-- Apply failure pattern: noise and spikes in the 3 days before each failure, peak on failure day, null (no data) the day after
DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS apply_failure_pattern_sensor_readings()
BEGIN
    DECLARE v_asset_id INT;
    DECLARE v_failure_date DATETIME;
    DECLARE v_failure_day DATE;
    DECLARE v_day_after DATE;
    DECLARE v_target_date DATE;
    DECLARE v_days_before INT DEFAULT 0;
    DECLARE v_intensity DECIMAL(5,4);
    DECLARE v_done INT DEFAULT 0;

    DECLARE failure_cursor CURSOR FOR
        SELECT asset_id, failure_date FROM assets_faliures ORDER BY asset_id, failure_date;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;

    OPEN failure_cursor;

    failure_loop: LOOP
        FETCH failure_cursor INTO v_asset_id, v_failure_date;
        IF v_done THEN
            LEAVE failure_loop;
        END IF;

        SET v_failure_day = DATE(v_failure_date);
        SET v_day_after = DATE_ADD(v_failure_day, INTERVAL 1 DAY);

        -- Null data the day after failure: remove all sensor readings for that asset on that day
        DELETE FROM plc_sensor_readings
        WHERE asset_id = v_asset_id
          AND DATE(reading_timestamp) = v_day_after;

        -- For the 3 days before and the failure day: add noise and spikes (peak on failure day)
        SET v_days_before = 0;
        WHILE v_days_before <= 3 DO
            SET v_target_date = DATE_SUB(v_failure_day, INTERVAL (3 - v_days_before) DAY);
            -- Intensity ramps: 0.25 (3 days before), 0.5 (2 before), 0.75 (1 before), 1.0 (failure day = peak)
            SET v_intensity = 0.25 + (v_days_before * 0.25);

            UPDATE plc_sensor_readings
            SET
                reading_value = CASE sensor_type
                    WHEN 'vibration' THEN reading_value * (1 + v_intensity * (0.35 + RAND() * 0.5)) + RAND() * 0.8 * v_intensity
                    WHEN 'rpm'         THEN reading_value * (1 + v_intensity * (RAND() * 0.25 - 0.08)) + (RAND() * 20 - 10) * v_intensity
                    WHEN 'power'       THEN reading_value * (1 + v_intensity * (0.25 + RAND() * 0.35)) + RAND() * 1.5 * v_intensity
                    WHEN 'current'     THEN reading_value * (1 + v_intensity * (0.3 + RAND() * 0.4)) + RAND() * 2 * v_intensity
                    WHEN 'pressure'    THEN IF(reading_value = 0, 0, GREATEST(0.1, reading_value * (1 - v_intensity * (0.05 + RAND() * 0.15)) + (RAND() * 0.5 - 0.25) * v_intensity))
                    WHEN 'flow'        THEN IF(reading_value = 0, 0, GREATEST(1, reading_value * (1 - v_intensity * (0.05 + RAND() * 0.2)) + (RAND() * 10 - 5) * v_intensity))
                    ELSE reading_value
                END,
                status = CASE sensor_type
                    WHEN 'vibration' THEN IF(reading_value * (1 + v_intensity * 0.6) > 6.0, 'critical', IF(reading_value * (1 + v_intensity * 0.6) > 4.0, 'warning', status))
                    WHEN 'current'   THEN IF(reading_value * (1 + v_intensity * 0.5) > 35, 'critical', IF(reading_value * (1 + v_intensity * 0.5) > 30, 'warning', status))
                    ELSE status
                END
            WHERE asset_id = v_asset_id
              AND DATE(reading_timestamp) = v_target_date;
            -- Re-apply status after value update (MySQL evaluates SET left-to-right, so status used old reading_value)
            UPDATE plc_sensor_readings
            SET status = CASE
                WHEN sensor_type = 'vibration' AND reading_value > 6.0 THEN 'critical'
                WHEN sensor_type = 'vibration' AND reading_value > 4.0 THEN 'warning'
                WHEN sensor_type = 'current' AND reading_value > 35 THEN 'critical'
                WHEN sensor_type = 'current' AND reading_value > 30 THEN 'warning'
                WHEN sensor_type = 'rpm' AND (reading_value < 1200 OR reading_value > 1800) THEN 'warning'
                ELSE status
            END
            WHERE asset_id = v_asset_id AND DATE(reading_timestamp) = v_target_date;

            SET v_days_before = v_days_before + 1;
        END WHILE;

    END LOOP failure_loop;

    CLOSE failure_cursor;
END$$

DELIMITER ;

CALL apply_failure_pattern_sensor_readings();
DROP PROCEDURE IF EXISTS apply_failure_pattern_sensor_readings;

-- Insert maintenance orders: visual inspections only (preventive)
DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS generate_maintenance_orders()
BEGIN
    DECLARE asset_id_var INT;
    DECLARE order_idx INT;
    DECLARE employee_id_var INT;
    DECLARE priority_var VARCHAR(20);
    DECLARE status_var VARCHAR(20);
    DECLARE scheduled_date_var DATETIME;
    DECLARE start_date_var DATETIME;
    DECLARE completion_date_var DATETIME;
    DECLARE estimated_cost_var DECIMAL(10,2);
    DECLARE actual_cost_var DECIMAL(10,2);
    DECLARE days_back INT;
    
    SET asset_id_var = 1;
    WHILE asset_id_var <= 8 DO
        SET order_idx = 0;
        WHILE order_idx < 120 DO  -- ~2-3 visual inspections per month per asset over 3 years
            SET days_back = FLOOR(RAND() * 1095);
            SET scheduled_date_var = DATE_SUB('2022-12-31 08:00:00', INTERVAL days_back DAY);
            SET scheduled_date_var = DATE_ADD(scheduled_date_var, INTERVAL FLOOR(RAND() * 10) HOUR);
            
            SET employee_id_var = 1 + FLOOR(RAND() * 8);
            SET priority_var = IF(RAND() < 0.2, 'high', IF(RAND() < 0.6, 'medium', 'low'));
            SET status_var = CASE
                WHEN RAND() < 0.65 THEN 'completed'
                WHEN RAND() < 0.80 THEN 'in_progress'
                ELSE 'pending'
            END;
            
            SET estimated_cost_var = 200.00 + (RAND() * 400.00);
            
            IF status_var = 'completed' THEN
                SET start_date_var = scheduled_date_var;
                SET completion_date_var = DATE_ADD(start_date_var, INTERVAL (1 + FLOOR(RAND() * 3)) HOUR);
                SET actual_cost_var = estimated_cost_var * (0.9 + RAND() * 0.2);
            ELSEIF status_var = 'in_progress' THEN
                SET start_date_var = scheduled_date_var;
                SET completion_date_var = NULL;
                SET actual_cost_var = NULL;
            ELSE
                SET start_date_var = NULL;
                SET completion_date_var = NULL;
                SET actual_cost_var = NULL;
            END IF;
            
            INSERT INTO mantainance_orders (asset_id, assigned_employee_id, order_type, priority, description, scheduled_date, start_date, completion_date, status, estimated_cost, actual_cost)
            VALUES (
                asset_id_var,
                employee_id_var,
                'preventive',
                priority_var,
                CONCAT('Visual inspection of asset ', asset_id_var, ' - inspection ', order_idx + 1),
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
            
            -- All orders are visual inspections; task is visual inspection
            SET task_name_var = 'Visual Inspection';
            SET task_desc_var = CONCAT('Visual inspection for order ', order_id_var, ' - task ', task_idx + 1);
            
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

-- Insert sample failure probability data (3 failures per asset per year)
INSERT INTO faliure_probability (asset_id, probability_score, risk_level, calculation_date, failure_count, warning_count, critical_sensor_count, days_since_maintenance, unresolved_failures, asset_age_days) VALUES
(1, 0.35, 'medium', '2022-12-31 10:00:00', 3, 1, 0, 45, 0, 1080),
(2, 0.30, 'low', '2022-12-31 10:00:00', 3, 0, 0, 30, 0, 1259),
(3, 0.40, 'medium', '2022-12-31 10:00:00', 3, 1, 0, 60, 0, 665),
(4, 0.50, 'medium', '2022-12-31 10:00:00', 3, 2, 0, 25, 0, 1516),
(5, 0.35, 'medium', '2022-12-31 10:00:00', 3, 0, 0, 20, 0, 840),
(6, 0.45, 'medium', '2022-12-31 10:00:00', 3, 1, 0, 15, 0, 526),
(7, 0.40, 'medium', '2022-12-31 10:00:00', 3, 1, 0, 40, 0, 1401),
(8, 0.55, 'high', '2022-12-31 10:00:00', 3, 2, 0, 10, 0, 2055);

-- Insert sample maintenance cost data (pumps and motors)
INSERT INTO mantainace_cost (asset_id, calculation_date, total_cost, total_transactions, avg_cost_per_transaction, maintenance_cost, repair_cost, upgrade_cost, other_cost, cost_last_12m, cost_last_6m, cost_last_3m, transactions_12m, transactions_6m, transactions_3m, avg_monthly_cost, avg_yearly_cost, cost_per_day, cost_trend, last_cost_date, days_since_last_cost, asset_age_days) VALUES
(1, '2022-12-31 10:00:00', 3000.00, 2, 1500.00, 800.00, 2200.00, 0.00, 0.00, 3000.00, 2200.00, 0.00, 2, 1, 0, 250.00, 3000.00, 2.78, 'stable', '2022-06-15', 199, 1080),
(2, '2022-12-31 10:00:00', 2400.00, 2, 1200.00, 600.00, 1800.00, 0.00, 0.00, 2400.00, 1800.00, 0.00, 2, 1, 0, 200.00, 2400.00, 1.91, 'stable', '2022-08-22', 131, 1259),
(3, '2022-12-31 10:00:00', 2500.00, 2, 1250.00, 700.00, 1800.00, 0.00, 0.00, 2500.00, 1800.00, 0.00, 2, 1, 0, 208.33, 2500.00, 3.76, 'stable', '2022-11-01', 60, 665),
(4, '2022-12-31 10:00:00', 2900.00, 2, 1450.00, 700.00, 2200.00, 0.00, 0.00, 2900.00, 2200.00, 700.00, 2, 2, 1, 241.67, 2900.00, 1.91, 'increasing', '2022-12-01', 30, 1516),
(5, '2022-12-31 10:00:00', 2000.00, 2, 1000.00, 500.00, 1500.00, 0.00, 0.00, 2000.00, 1500.00, 0.00, 2, 1, 0, 166.67, 2000.00, 2.38, 'stable', '2022-09-30', 92, 840),
(6, '2022-12-31 10:00:00', 2300.00, 2, 1150.00, 500.00, 1800.00, 0.00, 0.00, 2300.00, 1800.00, 500.00, 2, 1, 1, 191.67, 2300.00, 4.37, 'increasing', '2022-11-08', 53, 526),
(7, '2022-12-31 10:00:00', 3700.00, 2, 1850.00, 500.00, 3200.00, 0.00, 0.00, 3700.00, 3200.00, 0.00, 2, 1, 0, 308.33, 3700.00, 2.64, 'stable', '2022-07-15', 169, 1401),
(8, '2022-12-31 10:00:00', 3750.00, 2, 1875.00, 550.00, 3200.00, 0.00, 0.00, 3750.00, 3200.00, 550.00, 2, 1, 1, 312.50, 3750.00, 1.83, 'stable', '2022-12-12', 19, 2055);

-- Insert sample failure probability base data (features: mechanical vibration, RPM, power, current, pressure, flow, service days/hours, days since failure/inspection). ETL fills full time series.
INSERT INTO faliure_probability_base (asset_id, reading_date, mechanical_vibration, rpm, power, electrical_current, pressure, flow, asset_service_days, asset_service_hours, days_since_last_failure, days_since_last_inspection, faliure) VALUES
(1, '2022-12-31', 2.45, 1480.00, 17.20, 25.50, 4.20, 95.00, 1080, 25920.00, 58, 45, false),
(2, '2022-12-31', 1.85, 1520.00, 19.10, 27.00, 4.80, 110.00, 1259, 30216.00, 73, 30, false),
(3, '2022-12-31', 2.10, 1500.00, 21.50, 28.20, 5.10, 125.00, 665, 15960.00, 102, 60, false),
(4, '2022-12-31', 2.65, 1470.00, 23.00, 29.50, 5.40, 138.00, 1516, 36384.00, 30, 25, false),
(5, '2022-12-31', 1.95, 1750.00, 14.20, 24.00, 0.00, 0.00, 840, 20160.00, 77, 20, false),
(6, '2022-12-31', 2.25, 1780.00, 13.80, 26.50, 0.00, 0.00, 526, 12624.00, 53, 15, false),
(7, '2022-12-31', 2.55, 1720.00, 15.50, 27.80, 0.00, 0.00, 1401, 33624.00, 118, 40, false),
(8, '2022-12-31', 2.80, 1760.00, 16.20, 28.00, 0.00, 0.00, 2055, 49320.00, 19, 10, false);

-- Insert sample failure prediction data (LSTM predictions)
INSERT INTO faliure_prediction (asset_id, prediction_date, probability_score, predicted_failure, risk_level, model_version) VALUES
(1, '2022-12-31 10:00:00', 0.35, FALSE, 'medium', 'LSTM_v1.0'),
(2, '2022-12-31 10:00:00', 0.28, FALSE, 'low', 'LSTM_v1.0'),
(3, '2022-12-31 10:00:00', 0.42, FALSE, 'medium', 'LSTM_v1.0'),
(4, '2022-12-31 10:00:00', 0.48, FALSE, 'medium', 'LSTM_v1.0'),
(5, '2022-12-31 10:00:00', 0.32, FALSE, 'medium', 'LSTM_v1.0'),
(6, '2022-12-31 10:00:00', 0.38, FALSE, 'medium', 'LSTM_v1.0'),
(7, '2022-12-31 10:00:00', 0.45, FALSE, 'medium', 'LSTM_v1.0'),
(8, '2022-12-31 10:00:00', 0.52, TRUE, 'high', 'LSTM_v1.0');
