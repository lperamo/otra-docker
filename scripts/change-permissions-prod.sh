#!/bin/sh

echo "Adjusting permissions..."
chown -R www-data:www-data /var/www/html

# Read only folders
chmod 755 /var/www/html
chmod 755 /var/www/html/bin
chmod 775 /var/www/html/bundles
chmod 775 /var/www/html/config
chmod 755 /var/www/html/src
chmod 755 /var/www/html/tests
chmod 755 /var/www/html/vendor

# Folders that need write permissions
chmod -R 775 /var/www/html/cache
find /var/www/html/cache/php/sessions/ -type f -name 'sess_*' -exec chmod 600 {} \;
find /var/www/html/cache/php/sessions/ -type f ! -name 'sess_*' -exec chmod 775 {} \;
chmod -R 775 /var/www/html/logs
chmod -R 775 /var/www/html/web

# Read only configuration files
chmod 644 /var/www/html/.eslintrc.json
chmod 644 /var/www/html/.eslintrc.json.dist
chmod 644 /var/www/html/composer.json
chmod 644 /var/www/html/composer.lock
chmod 644 /var/www/html/tsconfig.json
chmod 644 /var/www/html/tsconfig.json.dist
