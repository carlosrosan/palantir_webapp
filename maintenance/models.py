from django.db import models
from django.core.validators import MinValueValidator


class Asset(models.Model):
    """Represents a physical asset that requires maintenance."""
    asset_id = models.AutoField(primary_key=True)
    asset_name = models.CharField(max_length=255)
    asset_type = models.CharField(max_length=100)
    location = models.CharField(max_length=255)
    installation_date = models.DateField()
    manufacturer = models.CharField(max_length=255, null=True, blank=True)
    model_number = models.CharField(max_length=100, null=True, blank=True)
    status = models.CharField(max_length=50, default='operational')  # operational, maintenance, retired
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'assets'
        ordering = ['asset_name']

    def __str__(self):
        return f"{self.asset_name} ({self.asset_type})"


class MaintenanceEmployee(models.Model):
    """Represents maintenance employees."""
    employee_id = models.AutoField(primary_key=True)
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    phone = models.CharField(max_length=20, null=True, blank=True)
    hire_date = models.DateField()
    department = models.CharField(max_length=100)
    position = models.CharField(max_length=100)
    salary = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'mantainance_employees'
        ordering = ['last_name', 'first_name']

    def __str__(self):
        return f"{self.first_name} {self.last_name}"


class MaintenanceEmployeeEducation(models.Model):
    """Represents education records for maintenance employees."""
    education_id = models.AutoField(primary_key=True)
    employee = models.ForeignKey(MaintenanceEmployee, on_delete=models.CASCADE, related_name='educations')
    degree = models.CharField(max_length=255)
    institution = models.CharField(max_length=255)
    graduation_year = models.IntegerField(null=True, blank=True)
    field_of_study = models.CharField(max_length=255, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'mantainance_employees_education'
        ordering = ['-graduation_year']

    def __str__(self):
        return f"{self.employee} - {self.degree}"


class AssetValue(models.Model):
    """Tracks the monetary value of assets over time."""
    value_id = models.AutoField(primary_key=True)
    asset = models.ForeignKey(Asset, on_delete=models.CASCADE, related_name='values')
    value_date = models.DateField()
    purchase_value = models.DecimalField(max_digits=12, decimal_places=2)
    current_value = models.DecimalField(max_digits=12, decimal_places=2)
    depreciation_rate = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    notes = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'asset_value'
        ordering = ['-value_date']

    def __str__(self):
        return f"{self.asset.asset_name} - {self.value_date}"


class AssetCost(models.Model):
    """Tracks costs associated with assets."""
    cost_id = models.AutoField(primary_key=True)
    asset = models.ForeignKey(Asset, on_delete=models.CASCADE, related_name='costs')
    cost_type = models.CharField(max_length=100)  # maintenance, repair, upgrade, etc.
    amount = models.DecimalField(max_digits=12, decimal_places=2, validators=[MinValueValidator(0)])
    cost_date = models.DateField()
    description = models.TextField(null=True, blank=True)
    vendor = models.CharField(max_length=255, null=True, blank=True)
    invoice_number = models.CharField(max_length=100, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'asset_costs'
        ordering = ['-cost_date']

    def __str__(self):
        return f"{self.asset.asset_name} - {self.cost_type} - ${self.amount}"


class AssetFailure(models.Model):
    """Records failures that occurred on assets."""
    failure_id = models.AutoField(primary_key=True)
    asset = models.ForeignKey(Asset, on_delete=models.CASCADE, related_name='failures')
    failure_date = models.DateTimeField()
    failure_type = models.CharField(max_length=100)
    severity = models.CharField(max_length=50)  # low, medium, high, critical
    description = models.TextField()
    root_cause = models.TextField(null=True, blank=True)
    downtime_hours = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    resolved = models.BooleanField(default=False)
    resolution_date = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'assets_faliures'
        ordering = ['-failure_date']

    def __str__(self):
        return f"{self.asset.asset_name} - {self.failure_type} - {self.failure_date}"


class PLCSensorReading(models.Model):
    """Stores sensor readings from PLC systems."""
    reading_id = models.AutoField(primary_key=True)
    asset = models.ForeignKey(Asset, on_delete=models.CASCADE, related_name='sensor_readings')
    sensor_name = models.CharField(max_length=255)
    sensor_type = models.CharField(max_length=100)  # temperature, pressure, vibration, etc.
    reading_value = models.DecimalField(max_digits=10, decimal_places=4)
    unit = models.CharField(max_length=50)
    reading_timestamp = models.DateTimeField()
    status = models.CharField(max_length=50, default='normal')  # normal, warning, critical
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'plc_sensor_readings'
        ordering = ['-reading_timestamp']
        indexes = [
            models.Index(fields=['asset', 'reading_timestamp']),
            models.Index(fields=['sensor_type', 'reading_timestamp']),
        ]

    def __str__(self):
        return f"{self.asset.asset_name} - {self.sensor_name} - {self.reading_value} {self.unit}"


class MaintenanceOrder(models.Model):
    """Represents maintenance work orders."""
    order_id = models.AutoField(primary_key=True)
    asset = models.ForeignKey(Asset, on_delete=models.CASCADE, related_name='maintenance_orders')
    assigned_employee = models.ForeignKey(MaintenanceEmployee, on_delete=models.SET_NULL, null=True, blank=True, related_name='orders')
    order_type = models.CharField(max_length=100)  # preventive, corrective, emergency
    priority = models.CharField(max_length=50)  # low, medium, high, urgent
    description = models.TextField()
    scheduled_date = models.DateTimeField(null=True, blank=True)
    start_date = models.DateTimeField(null=True, blank=True)
    completion_date = models.DateTimeField(null=True, blank=True)
    status = models.CharField(max_length=50, default='pending')  # pending, in_progress, completed, cancelled
    estimated_cost = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    actual_cost = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'mantainance_orders'
        ordering = ['-created_at']

    def __str__(self):
        return f"Order #{self.order_id} - {self.asset.asset_name} - {self.status}"


class MaintenanceTask(models.Model):
    """Represents individual tasks within maintenance orders."""
    task_id = models.AutoField(primary_key=True)
    order = models.ForeignKey(MaintenanceOrder, on_delete=models.CASCADE, related_name='tasks')
    task_name = models.CharField(max_length=255)
    task_description = models.TextField(null=True, blank=True)
    assigned_employee = models.ForeignKey(MaintenanceEmployee, on_delete=models.SET_NULL, null=True, blank=True, related_name='tasks')
    status = models.CharField(max_length=50, default='pending')  # pending, in_progress, completed, skipped
    estimated_hours = models.DecimalField(max_digits=6, decimal_places=2, null=True, blank=True)
    actual_hours = models.DecimalField(max_digits=6, decimal_places=2, null=True, blank=True)
    start_time = models.DateTimeField(null=True, blank=True)
    end_time = models.DateTimeField(null=True, blank=True)
    notes = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'mantainance_tasks'
        ordering = ['order', 'task_id']

    def __str__(self):
        return f"Task: {self.task_name} - Order #{self.order.order_id}"


class FailureProbability(models.Model):
    """Stores calculated failure probability for each asset."""
    probability_id = models.AutoField(primary_key=True)
    asset = models.OneToOneField(Asset, on_delete=models.CASCADE, related_name='failure_probability')
    probability_score = models.DecimalField(max_digits=5, decimal_places=4, validators=[MinValueValidator(0)])
    risk_level = models.CharField(max_length=50)  # low, medium, high, critical
    calculation_date = models.DateTimeField()
    failure_count = models.IntegerField(default=0)
    warning_count = models.IntegerField(default=0)
    critical_sensor_count = models.IntegerField(default=0)
    days_since_maintenance = models.IntegerField(null=True, blank=True)
    unresolved_failures = models.IntegerField(default=0)
    asset_age_days = models.IntegerField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'faliure_probability'
        ordering = ['-probability_score']
        indexes = [
            models.Index(fields=['risk_level']),
            models.Index(fields=['probability_score']),
        ]

    def __str__(self):
        return f"{self.asset.asset_name} - {self.probability_score:.2%} ({self.risk_level})"


class MaintenanceCost(models.Model):
    """Stores calculated maintenance cost metrics for each asset."""
    cost_calculation_id = models.AutoField(primary_key=True)
    asset = models.OneToOneField(Asset, on_delete=models.CASCADE, related_name='maintenance_cost')
    calculation_date = models.DateTimeField()
    total_cost = models.DecimalField(max_digits=12, decimal_places=2, default=0.00)
    total_transactions = models.IntegerField(default=0)
    avg_cost_per_transaction = models.DecimalField(max_digits=12, decimal_places=2, default=0.00)
    maintenance_cost = models.DecimalField(max_digits=12, decimal_places=2, default=0.00)
    repair_cost = models.DecimalField(max_digits=12, decimal_places=2, default=0.00)
    upgrade_cost = models.DecimalField(max_digits=12, decimal_places=2, default=0.00)
    other_cost = models.DecimalField(max_digits=12, decimal_places=2, default=0.00)
    cost_last_12m = models.DecimalField(max_digits=12, decimal_places=2, default=0.00)
    cost_last_6m = models.DecimalField(max_digits=12, decimal_places=2, default=0.00)
    cost_last_3m = models.DecimalField(max_digits=12, decimal_places=2, default=0.00)
    transactions_12m = models.IntegerField(default=0)
    transactions_6m = models.IntegerField(default=0)
    transactions_3m = models.IntegerField(default=0)
    avg_monthly_cost = models.DecimalField(max_digits=12, decimal_places=2, default=0.00)
    avg_yearly_cost = models.DecimalField(max_digits=12, decimal_places=2, default=0.00)
    cost_per_day = models.DecimalField(max_digits=10, decimal_places=4, default=0.0000)
    cost_trend = models.CharField(max_length=50, default='stable')  # increasing, decreasing, stable
    last_cost_date = models.DateField(null=True, blank=True)
    days_since_last_cost = models.IntegerField(null=True, blank=True)
    asset_age_days = models.IntegerField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'mantainace_cost'
        ordering = ['-total_cost']
        indexes = [
            models.Index(fields=['cost_trend']),
            models.Index(fields=['total_cost']),
        ]

    def __str__(self):
        return f"{self.asset.asset_name} - Total: ${self.total_cost}"


class FailurePrediction(models.Model):
    """Stores LSTM-based failure predictions for each asset."""
    prediction_id = models.AutoField(primary_key=True)
    asset = models.ForeignKey(Asset, on_delete=models.CASCADE, related_name='failure_predictions')
    prediction_date = models.DateTimeField()
    probability_score = models.DecimalField(max_digits=5, decimal_places=4, validators=[MinValueValidator(0)])
    predicted_failure = models.BooleanField(default=False)
    risk_level = models.CharField(max_length=50)  # low, medium, high, critical
    model_version = models.CharField(max_length=50, default='LSTM_v1.0')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'faliure_prediction'
        ordering = ['-prediction_date', '-probability_score']
        indexes = [
            models.Index(fields=['asset', 'prediction_date']),
            models.Index(fields=['risk_level']),
            models.Index(fields=['probability_score']),
            models.Index(fields=['predicted_failure']),
        ]
        unique_together = [['asset', 'prediction_date']]

    def __str__(self):
        return f"{self.asset.asset_name} - {self.probability_score:.2%} ({self.risk_level})"