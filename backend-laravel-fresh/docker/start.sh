#!/bin/sh
set -e

# Render's filesystem is ephemeral: a fresh container has no SQLite file,
# so create it and seed once (the seeders are not idempotent).
FRESH=0
if [ ! -f database/database.sqlite ]; then
    touch database/database.sqlite
    FRESH=1
fi

php artisan config:cache
php artisan migrate --force
if [ "$FRESH" = "1" ]; then
    php artisan db:seed --force
fi

exec php artisan serve --host=0.0.0.0 --port="${PORT:-10000}"
