from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse
from django.db.models import Q, Count, Sum, Avg
from .models import (
    Asset, AssetCost, AssetFailure, PLCSensorReading,
    MaintenanceOrder, FailureProbability, MaintenanceCost
)


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
    
    context = {
        'asset': asset,
        'recent_costs': recent_costs,
        'recent_failures': recent_failures,
        'recent_sensor_readings': recent_sensor_readings,
        'recent_orders': recent_orders,
        'total_costs': total_costs,
        'total_failures': total_failures,
        'unresolved_failures': unresolved_failures,
    }
    
    return render(request, 'maintenance/asset_details.html', context)


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
    """Display failure probability dashboard with risk analysis."""
    # Get all assets with their probability data
    assets_with_probability = Asset.objects.filter(
        failure_probability__isnull=False
    ).select_related('failure_probability').order_by('-failure_probability__probability_score')
    
    # Filter options
    risk_level_filter = request.GET.get('risk_level', '')
    if risk_level_filter:
        assets_with_probability = assets_with_probability.filter(
            failure_probability__risk_level=risk_level_filter
        )
    
    # Aggregate statistics
    total_assets = assets_with_probability.count()
    
    # Risk level distribution
    risk_distribution = FailureProbability.objects.values('risk_level').annotate(
        count=Count('probability_id')
    ).order_by('risk_level')
    
    # Average probability by risk level
    avg_probability_by_risk = FailureProbability.objects.values('risk_level').annotate(
        avg_probability=Avg('probability_score')
    ).order_by('risk_level')
    
    # Critical assets (high or critical risk)
    critical_assets = assets_with_probability.filter(
        Q(failure_probability__risk_level='high') | Q(failure_probability__risk_level='critical')
    )
    
    # Assets with unresolved failures
    assets_with_unresolved = assets_with_probability.filter(
        failure_probability__unresolved_failures__gt=0
    )
    
    # Assets with recent warnings
    assets_with_warnings = assets_with_probability.filter(
        failure_probability__warning_count__gt=0
    )
    
    # Top 10 highest risk assets
    top_risk_assets = assets_with_probability[:10]
    
    context = {
        'assets_with_probability': assets_with_probability,
        'total_assets': total_assets,
        'risk_distribution': risk_distribution,
        'avg_probability_by_risk': avg_probability_by_risk,
        'critical_assets': critical_assets,
        'assets_with_unresolved': assets_with_unresolved,
        'assets_with_warnings': assets_with_warnings,
        'top_risk_assets': top_risk_assets,
        'risk_levels': ['low', 'medium', 'high', 'critical'],
        'current_filter': {'risk_level': risk_level_filter}
    }
    
    return render(request, 'maintenance/failure_probability_dashboard.html', context)
