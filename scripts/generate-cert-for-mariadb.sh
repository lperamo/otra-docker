#!/bin/sh

# Load certificate information
. ../configuration/certs/cert.env

# Define the base directory for certificates
readonly base_cert_dir="../localCertificates"

# Ensure the MySQL certificates directory exists within localCertificates
readonly mariadb_cert_dir="$base_cert_dir/mariadb"
[ ! -d "$mariadb_cert_dir" ] && mkdir -p "$mariadb_cert_dir"

# Move into the MySQL certificates directory
cd "$mariadb_cert_dir" || exit

# Generate the CA's private key
echo "Generating CA's private key..."
openssl genrsa 4096 > ca-key.pem || { echo "Failed to generate CA's private key"; exit 1; }

# Generate the CA's certificate
echo "Generating CA's certificate..."
openssl req -new -x509 -nodes -days 3650 -key ca-key.pem -out ca-cert.pem \
    -subj "/C=$SSL_COUNTRY/ST=$SSL_STATE/L=$SSL_LOCALITY/O=$SSL_ORGANIZATION/CN=$SSL_COMMON_NAME" \
    || { echo "Failed to generate CA's certificate"; exit 1; }

# Generate the server's private key
echo "Generating server's private key..."
openssl genrsa 4096 > server-key.pem || { echo "Failed to generate server's private key"; exit 1; }

# Create a Certificate Signing Request (CSR) for the server
echo "Creating server's CSR..."
openssl req -new -key server-key.pem -out server-req.pem \
    -subj "/C=$SSL_COUNTRY/ST=$SSL_STATE/L=$SSL_LOCALITY/O=$SSL_ORGANIZATION/CN=$SSL_COMMON_NAME" \
    || { echo "Failed to create server's CSR"; exit 1; }

# Generate the server's certificate signed by the previously created CA
echo "Generating server's certificate signed by CA..."
openssl x509 -req -in server-req.pem -days 3650 -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 -out server-cert.pem \
    || { echo "Failed to generate server's certificate signed by CA"; exit 1; }

# Generate the client's private key
echo "Generating client's private key..."
openssl genrsa 4096 > client-key.pem || { echo "Failed to generate client's private key"; exit 1; }

# Create a Certificate Signing Request (CSR) for the client
echo "Creating client's CSR..."
openssl req -new -key client-key.pem -out client-req.pem \
    -subj "/C=$SSL_COUNTRY/ST=$SSL_STATE/L=$SSL_LOCALITY/O=$SSL_ORGANIZATION/CN=client" \
    || { echo "Failed to create client's CSR"; exit 1; }

# Generate the client's certificate signed by the previously created CA
echo "Generating client's certificate signed by CA..."
openssl x509 -req -in client-req.pem -days 3650 -CA ca-cert.pem -CAkey ca-key.pem -set_serial 02 -out client-cert.pem \
    || { echo "Failed to generate client's certificate signed by CA"; exit 1; }

# Cleaning up the CSR files and CA's private key as they are no longer needed
rm server-req.pem client-req.pem ca-key.pem

echo "SSL certificates for MariaDB have been generated in the $mariadb_cert_dir directory."
