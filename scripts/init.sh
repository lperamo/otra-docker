#!/bin/sh

# Check if OTRA is already installed
if [ ! -f /var/www/html/bin/otra.php ]; then
  echo "Installing OTRA..."

  # Clean /var/www/html if it's not empty
  if [ "$(ls -A /var/www/html)" ]; then
    echo "Cleaning /var/www/html..."
    rm -rf /var/www/html/*
  fi

  echo "Running composer install..."
  cp /tmp/composer.json /var/www/html/composer.json
  if ! composer install --no-dev --working-dir=/var/www/html; then
    echo "Failed to install dependencies."
    exit 1
  fi    
  echo "Adjusting configuration..."
  cp /tmp/DevAllConfig.php /var/www/html/config/dev/AllConfig.php
  cp /tmp/ProdAllConfig.php /var/www/html/config/prod/AllConfig.php
  
  php /var/www/html/bin/otra.php buildDev 0 7 false 1

  echo "OTRA installation complete."
else
  echo "OTRA is already installed."
fi
