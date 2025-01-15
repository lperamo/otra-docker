#!/bin/sh

# This script allows entering a Docker container for OTRA.
# Usage: ./enter-container.sh {base|nginx|other} [service]

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 {php-cli|nginx} [service]"
  exit 1
fi

# Parameters
readonly CONFIG_NAME="$1"
readonly SERVICE="${2:-app}"  # Default service is "app"
readonly CONFIG_FILE="docker-compose/docker-compose.$CONFIG_NAME.yml"

# Determine the container name based on the service
if [ "$SERVICE" = "nginx" ]; then
  readonly CONTAINER_NAME="otra-nginx"
else
  readonly CONTAINER_NAME="otra-app-fpm"
fi

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Configuration file not found: $CONFIG_FILE"
  exit 1
fi

# Check if the container is running
if docker ps -f "name=$CONTAINER_NAME" --format "{{.Names}}" | grep -q "$CONTAINER_NAME"; then
  # Container is running, connect to it
  docker exec -it "$CONTAINER_NAME" /bin/sh
else
  # Container is not running, use docker compose run to start it temporarily
  docker compose -f "$CONFIG_FILE" run --rm --service-ports "$SERVICE" /bin/sh
fi
