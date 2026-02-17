from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse, JsonResponse
from django.db import connection
from django.db.models import Q, Count, Sum, Avg
from .models import (
    Asset, AssetCost, AssetFailure, PLCSensorReading,
    MaintenanceOrder, FailureProbability, MaintenanceCost, FailurePrediction
)

# Columns in faliure_probability_base that can be graphed over time (numeric or date converted to value)
FAILURE_PROBABILITY_BASE_CHART_COLUMNS = [
    'asset_age_days', 'sensor_total_readings_30d', 'sensor_warning_count_30d', 'sensor_critical_count_30d',
    'sensor_avg_normal_value', 'sensor_avg_warning_value', 'sensor_avg_critical_value',
    'sensor_max_value', 'sensor_min_value', 'sensor_std_value',
    'failure_count_365d', 'failure_critical_count', 'failure_high_count', 'failure_medium_count', 'failure_low_count',
    'failure_avg_downtime', 'failure_total_downtime', 'failure_unresolved_count', 'days_since_last_failure',
    'task_total_365d', 'task_completed_count', 'task_in_progress_count', 'task_pending_count',
    'task_avg_estimated_hours', 'task_avg_actual_hours', 'task_total_hours', 'days_since_last_task',
    'order_total_365d', 'order_preventive_count', 'order_corrective_count', 'order_emergency_count', 'order_completed_count',
    'order_avg_estimated_cost', 'order_avg_actual_cost', 'order_total_actual_cost', 'days_since_last_order',
    'rpms', 'mechanical_load', 'vibration_acceleration', 'amplitude',
    'max_acceleration_last_day', 'variance_acceleration_last_day', 'inner_race_vibration', 'outer_race_vibration',
    'faliure',
]


def index(request):
    """Home page redirecting to asset list."""
    return asset_list(request)


def asset_list(request):
    """Display a list of all assets with key information."""
    assets = Asset.objects.all().select_related('failure_probability', 'maintenance_cost')
    
    # Get filter parameters
    asset_type_filter = request.GET.get('asset_type', '')
    status_filter = request.GET.get('status', '')
    risk_level_filter = request.GET.get('risk_level', '')
    
    # Apply filters
    if asset_type_filter:
        assets = assets.filter(asset_type=asset_type_filter)
    if status_filter:
        assets = assets.filter(status=status_filter)
    if risk_level_filter:
        assets = assets.filter(failure_probability__risk_level=risk_level_filter)
    
    # Get unique values for filter dropdowns
    asset_types = Asset.objects.values_list('asset_type', flat=True).distinct()
    statuses = Asset.objects.values_list('status', flat=True).distinct()
    risk_levels = FailureProbability.objects.values_list('risk_level', flat=True).distinct()
    
    context = {
        'assets': assets,
        'asset_types': asset_types,
        'statuses': statuses,
        'risk_levels': risk_levels,
        'current_filters': {
            'asset_type': asset_type_filter,
            'status': status_filter,
            'risk_level': risk_level_filter,
        }
    }
    
    return render(request, 'maintenance/asset_list.html', context)


def asset_details(request, asset_id):
    """Display detailed information about a specific asset."""
    asset = get_object_or_404(Asset.objects.select_related(
        'failure_probability', 'maintenance_cost'
    ), asset_id=asset_id)
    
    # Get related data
    recent_costs = AssetCost.objects.filter(asset=asset).order_by('-cost_date')[:10]
    recent_failures = AssetFailure.objects.filter(asset=asset).order_by('-failure_date')[:10]
    recent_sensor_readings = PLCSensorReading.objects.filter(asset=asset).order_by('-reading_timestamp')[:20]
    recent_orders = MaintenanceOrder.objects.filter(asset=asset).order_by('-created_at')[:10]
    
    # Statistics
    total_costs = AssetCost.objects.filter(asset=asset).aggregate(
        total=Sum('amount'),
        count=Count('cost_id')
    )
    
    total_failures = AssetFailure.objects.filter(asset=asset).count()
    unresolved_failures = AssetFailure.objects.filter(asset=asset, resolved=False).count()
    
    chart_columns = [(c, c.replace('_', ' ').title()) for c in FAILURE_PROBABILITY_BASE_CHART_COLUMNS]
    context = {
        'asset': asset,
        'recent_costs': recent_costs,
        'recent_failures': recent_failures,
        'recent_sensor_readings': recent_sensor_readings,
        'recent_orders': recent_orders,
        'total_costs': total_costs,
        'total_failures': total_failures,
        'unresolved_failures': unresolved_failures,
        'failure_probability_base_columns': chart_columns,
    }
    
    return render(request, 'maintenance/asset_details.html', context)


def asset_failure_probability_base_chart_data(request, asset_id):
    """Return JSON time series for a selected faliure_probability_base column (reading_date vs column value)."""
    get_object_or_404(Asset, asset_id=asset_id)
    column = request.GET.get('column', '').strip()
    if not column or column not in FAILURE_PROBABILITY_BASE_CHART_COLUMNS:
        return JsonResponse({'error': 'Invalid or missing column'}, status=400)
    with connection.cursor() as cursor:
        cursor.execute(
            f'SELECT reading_date, `{column}` FROM faliure_probability_base WHERE asset_id = %s ORDER BY reading_date',
            [asset_id],
        )
        rows = cursor.fetchall()
    labels = []
    values = []
    for reading_date, value in rows:
        labels.append(reading_date.isoformat() if hasattr(reading_date, 'isoformat') else str(reading_date))
        values.append(float(value) if value is not None else None)
    return JsonResponse({'labels': labels, 'values': values, 'column': column})


def maintenance_cost_dashboard(request):
    """Display maintenance cost dashboard with aggregated data."""
    # Get all assets with their cost data
    assets_with_costs = Asset.objects.filter(
        maintenance_cost__isnull=False
    ).select_related('maintenance_cost').order_by('-maintenance_cost__total_cost')
    
    # Filter options
    cost_trend_filter = request.GET.get('cost_trend', '')
    if cost_trend_filter:
        assets_with_costs = assets_with_costs.filter(maintenance_cost__cost_trend=cost_trend_filter)
    
    # Aggregate statistics
    total_maintenance_cost = MaintenanceCost.objects.aggregate(
        total=Sum('total_cost'),
        avg_monthly=Avg('avg_monthly_cost'),
        avg_yearly=Avg('avg_yearly_cost')
    )
    
    # Cost by type
    cost_by_type = MaintenanceCost.objects.aggregate(
        total_maintenance=Sum('maintenance_cost'),
        total_repair=Sum('repair_cost'),
        total_upgrade=Sum('upgrade_cost'),
        total_other=Sum('other_cost')
    )
    
    # Cost trends
    increasing_costs = MaintenanceCost.objects.filter(cost_trend='increasing').count()
    decreasing_costs = MaintenanceCost.objects.filter(cost_trend='decreasing').count()
    stable_costs = MaintenanceCost.objects.filter(cost_trend='stable').count()
    
    # Top 10 most expensive assets
    top_expensive = assets_with_costs[:10]
    
    # Assets with highest monthly costs
    high_monthly_costs = Asset.objects.filter(
        maintenance_cost__isnull=False
    ).select_related('maintenance_cost').order_by('-maintenance_cost__avg_monthly_cost')[:10]
    
    context = {
        'assets_with_costs': assets_with_costs,
        'total_maintenance_cost': total_maintenance_cost,
        'cost_by_type': cost_by_type,
        'increasing_costs': increasing_costs,
        'decreasing_costs': decreasing_costs,
        'stable_costs': stable_costs,
        'top_expensive': top_expensive,
        'high_monthly_costs': high_monthly_costs,
        'cost_trends': ['increasing', 'decreasing', 'stable'],
        'current_filter': {'cost_trend': cost_trend_filter}
    }
    
    return render(request, 'maintenance/maintenance_cost_dashboard.html', context)


def failure_probability_dashboard(request):
    """Display failure probability dashboard with risk analysis using LSTM predictions."""
    from django.db.models import Max
    
    # Get the latest prediction for each asset
    latest_predictions = FailurePrediction.objects.filter(
        asset_id__in=Asset.objects.values_list('asset_id', flat=True)
    ).values('asset_id').annotate(
        latest_date=Max('prediction_date')
    )
    
    # Get assets with their latest predictions
    assets_with_predictions = []
    for pred in latest_predictions:
        try:
            asset = Asset.objects.get(asset_id=pred['asset_id'])
            latest_pred = FailurePrediction.objects.filter(
                asset=asset,
                prediction_date=pred['latest_date']
            ).first()
            if latest_pred:
                assets_with_predictions.append({
                    'asset': asset,
                    'prediction': latest_pred
                })
        except Asset.DoesNotExist:
            continue
    
    # Sort by probability score descending
    assets_with_predictions.sort(key=lambda x: x['prediction'].probability_score, reverse=True)
    
    # Filter options
    risk_level_filter = request.GET.get('risk_level', '')
    if risk_level_filter:
        assets_with_predictions = [
            item for item in assets_with_predictions 
            if item['prediction'].risk_level == risk_level_filter
        ]
    
    # Aggregate statistics
    total_assets = len(assets_with_predictions)
    
    # Risk level distribution from predictions
    risk_distribution = FailurePrediction.objects.values('risk_level').annotate(
        count=Count('prediction_id')
    ).order_by('risk_level')
    
    # Average probability by risk level
    avg_probability_by_risk = FailurePrediction.objects.values('risk_level').annotate(
        avg_probability=Avg('probability_score')
    ).order_by('risk_level')
    
    # Critical assets (high or critical risk)
    critical_assets = [
        item for item in assets_with_predictions
        if item['prediction'].risk_level in ['high', 'critical']
    ]
    
    # Assets with predicted failures
    assets_with_predicted_failures = [
        item for item in assets_with_predictions
        if item['prediction'].predicted_failure
    ]
    
    # Assets with warnings (using old failure_probability for now, or can be removed)
    assets_with_warnings = Asset.objects.filter(
        failure_probability__warning_count__gt=0
    )
    
    # Top 10 highest risk assets
    top_risk_assets = assets_with_predictions[:10]
    
    context = {
        'assets_with_predictions': assets_with_predictions,
        'total_assets': total_assets,
        'risk_distribution': risk_distribution,
        'avg_probability_by_risk': avg_probability_by_risk,
        'critical_assets': critical_assets,
        'assets_with_unresolved': assets_with_predicted_failures,
        'assets_with_warnings': assets_with_warnings,
        'top_risk_assets': top_risk_assets,
        'risk_levels': ['low', 'medium', 'high', 'critical'],
        'current_filter': {'risk_level': risk_level_filter}
    }
    
    return render(request, 'maintenance/failure_probability_dashboard.html', context)
