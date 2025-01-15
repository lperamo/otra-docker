#!/bin/sh

echo "Adjusting permissions for development..."
chown -R www-data:www-data /var/www/html

# Read write permissions for all
chmod -R 777 /var/www/html

# Session files with restrictive permissions
find /var/www/html/cache/php/sessions/ -type f -name 'sess_*' -exec chmod 600 {} \;

echo "Permissions adjusted for development."
