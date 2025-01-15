#!/bin/sh

# This script proxies OTRA calls to the Docker container.
# Usage: ./otra.sh [command] [options]

# Parameters
readonly OTRA_BINARY="/var/www/html/bin/otra.php"
readonly SERVICE_NAME="app"  # Nom du service dans docker-compose.yml

# Determine the active container and configuration file
if docker ps -af "name=otra-app-cli" --format "{{.Names}}" | grep -q "otra-app-cli"; then
  readonly CONTAINER_NAME="otra-app-cli"
  readonly CONFIG_FILE="docker-compose/docker-compose.php-cli.yml"
elif docker ps -af "name=otra-app-fpm" --format "{{.Names}}" | grep -q "otra-app-fpm"; then
  readonly CONTAINER_NAME="otra-app-fpm"
  readonly CONFIG_FILE="docker-compose/docker-compose.php-fpm.yml"
else
  echo "No container found. Please check your Docker setup."
  exit 1
fi

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Configuration file not found: $CONFIG_FILE"
  exit 1
fi

# Check if the container is running
if docker ps -f "name=$CONTAINER_NAME" --format "{{.Names}}" | grep -q "$CONTAINER_NAME"; then
  # Container is running, execute command directly
  docker exec -it --user www-data -w /var/www/html "$CONTAINER_NAME" php "$OTRA_BINARY" "$@"
else
  # Container is not running, use docker compose run to start it and execute the command
  docker compose -f "$CONFIG_FILE" run --rm --service-ports --user www-data "$SERVICE_NAME" php "$OTRA_BINARY" "$@"
fi
