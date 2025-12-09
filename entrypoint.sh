#!/bin/sh
set -e

# Run database migrations
echo "Running migrations..."
python manage.py migrate --noinput

# Create superuser if not exists
echo "Creating superuser..."
python - <<EOF
from django.contrib.auth import get_user_model
User = get_user_model()
email='${SUPERUSER_EMAIL}'
password='${SUPERUSER_PASSWORD}'
if not User.objects.filter(email=email).exists():
    User.objects.create_superuser(email=email, password=password)
EOF

# Start Gunicorn server
echo "Starting server..."
exec gunicorn mikroman.wsgi:application --bind 0.0.0.0:8181