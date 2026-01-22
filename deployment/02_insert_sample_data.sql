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

-- Insert sample PLC sensor readings
INSERT INTO plc_sensor_readings (asset_id, sensor_name, sensor_type, reading_value, unit, reading_timestamp, status) VALUES
(1, 'Temperature Sensor 1', 'temperature', 75.5, 'Celsius', '2022-11-01 08:00:00', 'normal'),
(1, 'Pressure Sensor 1', 'pressure', 8.5, 'bar', '2022-11-01 08:00:00', 'normal'),
(1, 'Vibration Sensor 1', 'vibration', 2.3, 'mm/s', '2022-11-01 08:00:00', 'normal'),
(1, 'Temperature Sensor 1', 'temperature', 82.0, 'Celsius', '2022-11-01 14:00:00', 'warning'),
(1, 'Pressure Sensor 1', 'pressure', 8.2, 'bar', '2022-11-01 14:00:00', 'normal'),
(2, 'Flow Sensor 1', 'flow', 125.5, 'L/min', '2022-11-01 09:00:00', 'normal'),
(2, 'Pressure Sensor 1', 'pressure', 3.2, 'bar', '2022-11-01 09:00:00', 'normal'),
(2, 'Temperature Sensor 1', 'temperature', 45.0, 'Celsius', '2022-11-01 09:00:00', 'normal'),
(3, 'Speed Sensor 1', 'speed', 1.5, 'm/s', '2022-11-01 10:00:00', 'normal'),
(3, 'Load Sensor 1', 'load', 850.0, 'kg', '2022-11-01 10:00:00', 'normal'),
(4, 'Temperature Sensor 1', 'temperature', 22.5, 'Celsius', '2022-11-01 11:00:00', 'normal'),
(4, 'Humidity Sensor 1', 'humidity', 45.0, '%', '2022-11-01 11:00:00', 'normal'),
(4, 'Pressure Sensor 1', 'pressure', 1.0, 'bar', '2022-11-01 11:00:00', 'normal'),
(5, 'Voltage Sensor 1', 'voltage', 480.0, 'V', '2022-11-01 12:00:00', 'normal'),
(5, 'Current Sensor 1', 'current', 125.5, 'A', '2022-11-01 12:00:00', 'normal'),
(5, 'Frequency Sensor 1', 'frequency', 60.0, 'Hz', '2022-11-01 12:00:00', 'normal'),
(6, 'Temperature Sensor 1', 'temperature', 65.0, 'Celsius', '2022-11-01 13:00:00', 'normal'),
(6, 'Vibration Sensor 1', 'vibration', 1.8, 'mm/s', '2022-11-01 13:00:00', 'normal'),
(7, 'Temperature Sensor 1', 'temperature', 95.0, 'Celsius', '2022-11-01 14:00:00', 'normal'),
(7, 'Pressure Sensor 1', 'pressure', 12.5, 'bar', '2022-11-01 14:00:00', 'normal'),
(8, 'Vibration Sensor 1', 'vibration', 4.2, 'mm/s', '2022-11-01 15:00:00', 'warning'),
(8, 'Temperature Sensor 1', 'temperature', 550.0, 'Celsius', '2022-11-01 15:00:00', 'normal'),
(8, 'Pressure Sensor 1', 'pressure', 45.0, 'bar', '2022-11-01 15:00:00', 'normal');

-- Insert sample maintenance orders
INSERT INTO mantainance_orders (asset_id, assigned_employee_id, order_type, priority, description, scheduled_date, start_date, completion_date, status, estimated_cost, actual_cost) VALUES
(1, 1, 'preventive', 'medium', 'Quarterly compressor maintenance and inspection', '2022-12-01 08:00:00', NULL, NULL, 'pending', 2500.00, NULL),
(2, 2, 'preventive', 'low', 'Monthly pump system check', '2022-11-15 09:00:00', '2022-11-15 09:00:00', '2022-11-15 12:00:00', 'completed', 1200.00, 1150.00),
(3, 3, 'corrective', 'medium', 'Fix conveyor belt alignment issue', '2022-11-05 10:00:00', '2022-11-05 10:00:00', '2022-11-05 14:30:00', 'completed', 1800.00, 1750.00),
(4, 4, 'preventive', 'high', 'Annual HVAC system service', '2022-11-10 08:00:00', '2022-11-10 08:00:00', NULL, 'in_progress', 2200.00, NULL),
(5, 7, 'preventive', 'high', 'Generator quarterly service', '2022-12-05 07:00:00', NULL, NULL, 'pending', 4500.00, NULL),
(6, 1, 'corrective', 'medium', 'Motor bearing replacement follow-up inspection', '2022-10-05 11:00:00', '2022-10-05 11:00:00', '2022-10-05 13:00:00', 'completed', 500.00, 500.00),
(7, 4, 'preventive', 'medium', 'Boiler annual inspection', '2022-12-10 09:00:00', NULL, NULL, 'pending', 2800.00, NULL),
(8, 7, 'corrective', 'urgent', 'Address excessive turbine vibration', '2022-11-02 06:00:00', '2022-11-02 06:00:00', NULL, 'in_progress', 15000.00, NULL),
(1, 6, 'emergency', 'urgent', 'Emergency compressor shutdown and inspection', '2022-11-20 16:00:00', '2022-11-20 16:00:00', '2022-11-20 20:00:00', 'completed', 5000.00, 5200.00),
(2, 2, 'preventive', 'low', 'Pump system upgrade installation', '2022-08-20 08:00:00', '2022-08-20 08:00:00', '2022-08-22 17:00:00', 'completed', 3500.00, 3450.00);

-- Insert sample maintenance tasks
INSERT INTO mantainance_tasks (order_id, task_name, task_description, assigned_employee_id, status, estimated_hours, actual_hours, start_time, end_time, notes) VALUES
(1, 'Oil Change', 'Replace compressor oil and filter', 1, 'pending', 2.0, NULL, NULL, NULL, NULL),
(1, 'Inspection', 'Full system inspection and testing', 1, 'pending', 3.0, NULL, NULL, NULL, NULL),
(2, 'Visual Inspection', 'Check pump for leaks and wear', 2, 'completed', 1.0, 0.75, '2022-11-15 09:00:00', '2022-11-15 09:45:00', 'No issues found'),
(2, 'Performance Test', 'Test pump flow and pressure', 2, 'completed', 1.5, 1.5, '2022-11-15 09:45:00', '2022-11-15 11:15:00', 'Performance within specifications'),
(3, 'Belt Alignment', 'Adjust conveyor belt alignment', 3, 'completed', 2.0, 2.5, '2022-11-05 10:00:00', '2022-11-05 12:30:00', 'Required additional adjustments'),
(3, 'Belt Replacement', 'Replace worn section of belt', 3, 'completed', 2.0, 2.0, '2022-11-05 12:30:00', '2022-11-05 14:30:00', 'Belt replaced successfully'),
(4, 'Filter Replacement', 'Replace HVAC air filters', 4, 'completed', 1.0, 1.0, '2022-11-10 08:00:00', '2022-11-10 09:00:00', NULL),
(4, 'Condenser Cleaning', 'Clean condenser coils', 4, 'in_progress', 3.0, NULL, '2022-11-10 09:00:00', NULL, 'In progress'),
(4, 'System Testing', 'Test HVAC system performance', 4, 'pending', 2.0, NULL, NULL, NULL, NULL),
(5, 'Oil Analysis', 'Collect and analyze generator oil sample', 7, 'pending', 1.0, NULL, NULL, NULL, NULL),
(5, 'Load Testing', 'Perform generator load test', 7, 'pending', 4.0, NULL, NULL, NULL, NULL),
(6, 'Post-Repair Inspection', 'Inspect motor after bearing replacement', 1, 'completed', 1.5, 2.0, '2022-10-05 11:00:00', '2022-10-05 13:00:00', 'Motor running smoothly'),
(7, 'Boiler Inspection', 'Full boiler safety inspection', 4, 'pending', 4.0, NULL, NULL, NULL, NULL),
(7, 'Pressure Test', 'Test boiler pressure systems', 4, 'pending', 2.0, NULL, NULL, NULL, NULL),
(8, 'Vibration Analysis', 'Perform detailed vibration analysis', 7, 'completed', 3.0, 3.5, '2022-11-02 06:00:00', '2022-11-02 09:30:00', 'Bearing wear confirmed'),
(8, 'Bearing Replacement', 'Replace turbine bearings', 7, 'in_progress', 12.0, NULL, '2022-11-02 09:30:00', NULL, 'Replacement in progress'),
(9, 'Emergency Shutdown', 'Safely shutdown compressor', 6, 'completed', 0.5, 0.5, '2022-11-20 16:00:00', '2022-11-20 16:30:00', NULL),
(9, 'Diagnostic Check', 'Diagnose compressor issue', 6, 'completed', 2.0, 2.5, '2022-11-20 16:30:00', '2022-11-20 19:00:00', 'Found minor issue, resolved'),
(9, 'Restart and Test', 'Restart compressor and verify operation', 6, 'completed', 1.0, 1.0, '2022-11-20 19:00:00', '2022-11-20 20:00:00', 'System operational'),
(10, 'Remove Old Control Panel', 'Remove existing control panel', 2, 'completed', 4.0, 3.5, '2022-08-20 08:00:00', '2022-08-20 11:30:00', NULL),
(10, 'Install New Control Panel', 'Install and wire new control panel', 2, 'completed', 8.0, 8.5, '2022-08-20 11:30:00', '2022-08-21 20:00:00', 'Installation completed'),
(10, 'System Configuration', 'Configure new control system', 2, 'completed', 4.0, 4.0, '2022-08-22 08:00:00', '2022-08-22 12:00:00', 'Configuration successful'),
(10, 'Testing and Commissioning', 'Test new system and commission', 2, 'completed', 5.0, 5.0, '2022-08-22 12:00:00', '2022-08-22 17:00:00', 'System fully operational');

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
