from django.contrib import admin
from .models import (
    Asset, MaintenanceEmployee, MaintenanceEmployeeEducation,
    AssetValue, AssetCost, AssetFailure, PLCSensorReading,
    MaintenanceOrder, MaintenanceTask, FailureProbability, MaintenanceCost
)


@admin.register(Asset)
class AssetAdmin(admin.ModelAdmin):
    list_display = ['asset_id', 'asset_name', 'asset_type', 'location', 'status', 'installation_date']
    list_filter = ['asset_type', 'status', 'location']
    search_fields = ['asset_name', 'asset_type', 'location']


@admin.register(MaintenanceEmployee)
class MaintenanceEmployeeAdmin(admin.ModelAdmin):
    list_display = ['employee_id', 'first_name', 'last_name', 'email', 'department', 'position', 'hire_date']
    list_filter = ['department', 'position']
    search_fields = ['first_name', 'last_name', 'email']


@admin.register(MaintenanceEmployeeEducation)
class MaintenanceEmployeeEducationAdmin(admin.ModelAdmin):
    list_display = ['education_id', 'employee', 'degree', 'institution', 'graduation_year']
    list_filter = ['graduation_year']
    search_fields = ['employee__first_name', 'employee__last_name', 'degree', 'institution']


@admin.register(AssetValue)
class AssetValueAdmin(admin.ModelAdmin):
    list_display = ['value_id', 'asset', 'value_date', 'purchase_value', 'current_value']
    list_filter = ['value_date']
    search_fields = ['asset__asset_name']


@admin.register(AssetCost)
class AssetCostAdmin(admin.ModelAdmin):
    list_display = ['cost_id', 'asset', 'cost_type', 'amount', 'cost_date', 'vendor']
    list_filter = ['cost_type', 'cost_date']
    search_fields = ['asset__asset_name', 'vendor', 'description']


@admin.register(AssetFailure)
class AssetFailureAdmin(admin.ModelAdmin):
    list_display = ['failure_id', 'asset', 'failure_date', 'failure_type', 'severity', 'resolved']
    list_filter = ['failure_type', 'severity', 'resolved', 'failure_date']
    search_fields = ['asset__asset_name', 'failure_type', 'description']


@admin.register(PLCSensorReading)
class PLCSensorReadingAdmin(admin.ModelAdmin):
    list_display = ['reading_id', 'asset', 'sensor_name', 'sensor_type', 'reading_value', 'unit', 'reading_timestamp', 'status']
    list_filter = ['sensor_type', 'status', 'reading_timestamp']
    search_fields = ['asset__asset_name', 'sensor_name']


@admin.register(MaintenanceOrder)
class MaintenanceOrderAdmin(admin.ModelAdmin):
    list_display = ['order_id', 'asset', 'order_type', 'priority', 'status', 'assigned_employee', 'scheduled_date']
    list_filter = ['order_type', 'priority', 'status', 'scheduled_date']
    search_fields = ['asset__asset_name', 'description']


@admin.register(MaintenanceTask)
class MaintenanceTaskAdmin(admin.ModelAdmin):
    list_display = ['task_id', 'order', 'task_name', 'status', 'assigned_employee', 'estimated_hours', 'actual_hours']
    list_filter = ['status']
    search_fields = ['task_name', 'task_description']


@admin.register(FailureProbability)
class FailureProbabilityAdmin(admin.ModelAdmin):
    list_display = ['probability_id', 'asset', 'probability_score', 'risk_level', 'calculation_date', 'failure_count', 'unresolved_failures']
    list_filter = ['risk_level', 'calculation_date']
    search_fields = ['asset__asset_name']
    readonly_fields = ['calculation_date', 'created_at', 'updated_at']


@admin.register(MaintenanceCost)
class MaintenanceCostAdmin(admin.ModelAdmin):
    list_display = ['cost_calculation_id', 'asset', 'total_cost', 'cost_last_12m', 'avg_monthly_cost', 'cost_trend', 'calculation_date']
    list_filter = ['cost_trend', 'calculation_date']
    search_fields = ['asset__asset_name']
    readonly_fields = ['calculation_date', 'created_at', 'updated_at']

