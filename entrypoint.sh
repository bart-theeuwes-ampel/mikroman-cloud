#!/bin/sh
set -e

# Set the correct working directory
WORKDIR=/mikroman   # <-- adjust this after inspecting base image
cd $WORKDIR || exit 1

# Run migrations (ignore errors temporarily to avoid crashing on missing DB)
echo "Running migrations..."
python manage.py migrate --noinput || echo "Migration failed, maybe DB not ready yet"

# Create superuser if Django is ready
echo "Creating superuser..."
python - <<EOF || echo "Superuser creation skipped"
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