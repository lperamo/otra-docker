# OTRA Docker Environments

This repository contains example Docker and Docker Compose files to deploy OTRA in various environments.

## Content
`docker-compose` folder contains:
  - `docker-compose.php-cli.yml`: Creates a container for PHP scripts only.
  - `docker-compose.nginx.yml`: Creates a PHP-FPM container and an NGINX container.
  - `docker-compose.full.yml`: Creates a PHP-FPM container, an NGINX container and a MariaDB container.
- `Dockerfiles` folder contains:
  - `Dockerfile.php-cli`: An image with PHP-CLI on Alpine.
  - `Dockerfile.php-fpm`: An image with PHP-FPM on Alpine.
  - `Dockerfile.nginx`: An image with Nginx on Alpine.

## To install

### Get this repo

Clone this repository:
```bash
git clone https://github.com/lperamo/otra-docker.git
```

### OTRA PHP-CLI (script only)

```bash
./install-otra-cli.sh
```

### OTRA PHP-FPM + NGINX (simple websites) 
```bash
./install-otra-nginx.sh
```

### OTRA PHP-FPM + NGINX + MariaDB (full websites)
```bash
./install-otra-full.sh
```

### OTRA founder version
```bash
./install-otra-founder.sh
```

## Generating self-signed certificates
For the site:
```bash
cd scripts
./generate-cert.sh
```

For MariaDB:
```bash
cd scripts
./generate-cert-for-mariadb.sh
```
