"""
Root URL configuration. Includes app URLs under the 'maintenance' namespace
so {% url 'maintenance:...' %} works in templates.
"""
from django.urls import path, include

urlpatterns = [
    path('', include(('palantir_webapp.urls', 'maintenance'))),
]
