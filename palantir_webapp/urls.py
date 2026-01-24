from django.urls import path
from . import views

app_name = 'maintenance'

urlpatterns = [
    path('', views.index, name='index'),
    path('assets/', views.asset_list, name='asset_list'),
    path('assets/<int:asset_id>/', views.asset_details, name='asset_details'),
    path('dashboard/maintenance-cost/', views.maintenance_cost_dashboard, name='maintenance_cost_dashboard'),
    path('dashboard/failure-probability/', views.failure_probability_dashboard, name='failure_probability_dashboard'),
]

