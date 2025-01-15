#!/bin/sh

# Create a temporary file
TMP_FILE=$(mktemp)

# Replace the __VARIABLE__ placeholders by the environment variable values
sed "s|__APP_ROOT__|${APP_ROOT}|g" /etc/nginx/nginx.conf.template > "${TMP_FILE}"
sed -i "s|__DOMAIN_NAME_DEV__|${DOMAIN_NAME_DEV}|g" "${TMP_FILE}"
sed -i "s|__DOMAIN_NAME__|${DOMAIN_NAME}|g" "${TMP_FILE}"
sed -i "s|__FASTCGI_HOST__|${FASTCGI_HOST}|g" "${TMP_FILE}"
sed -i "s|__FASTCGI_PORT__|${FASTCGI_PORT}|g" "${TMP_FILE}"
sed -i "s|__CERT_PATH__|${CERT_PATH}|g" "${TMP_FILE}"

# Replace the template file by the temporary file
mv "${TMP_FILE}" /etc/nginx/nginx.conf

nginx -g 'daemon off;'
