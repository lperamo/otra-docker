#!/usr/bin/env bash

# This script installs OTRA.
# Usage: ./install-otra-base.sh

docker compose -f docker-compose/docker-compose.php-cli.yml up
