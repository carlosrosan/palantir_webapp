"""
WSGI config for the Palantir project.
"""

import os

from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'palantir_webapp.settings')

application = get_wsgi_application()
