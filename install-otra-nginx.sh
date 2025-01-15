#!/usr/bin/env bash

# This script installs OTRA.
# Usage: ./install-otra-nginx.sh

docker compose -f docker-compose/docker-compose.nginx.yml up
