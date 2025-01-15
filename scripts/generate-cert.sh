#!/bin/sh

# Load certificate information
pwd
. ../configuration/certs/cert.env

# Define directories and file names
readonly nginx_cert_dir="../localCertificates/nginx"
readonly certs_conf_dir="../configuration/certs"
readonly ca_key="$nginx_cert_dir/ca.key"
readonly ca_cert="$nginx_cert_dir/site-ca.crt"
readonly server_key="$nginx_cert_dir/nginx-selfsigned.key"
readonly server_csr="$nginx_cert_dir/nginx.csr"
readonly server_cert="$nginx_cert_dir/nginx-selfsigned.crt"
readonly ca_config_file="$certs_conf_dir/myCA.cnf"
readonly server_config_file="$certs_conf_dir/nginx_cert_config.cnf"

# Ensure the directory exists
mkdir -p "$nginx_cert_dir" || { echo "Could not create nginx certificates directory."; exit 1; }

# Fonction pour vérifier si un fichier a été modifié
check_file_modified() {
    local file_to_check="$1"
    local reference_file="$2"
    
    # Utiliser find pour vérifier si le fichier a été modifié après le fichier de référence
    if [ -n "$(find "$file_to_check" -prune -newer "$reference_file" 2>/dev/null)" ]; then
        return 0  # Le fichier a été modifié
    else
        return 1  # Le fichier n'a pas été modifié
    fi
}

# Vérifier si les fichiers de configuration ont été modifiés ou si la clé/certificat CA n'existe pas
# Generate the CA's private key and certificate if they don't exist
if [ ! -f "$ca_cert" ] || [ ! -f "$ca_key" ] || \
   check_file_modified "$ca_config_file" "$ca_cert" || \
   check_file_modified "$server_config_file" "$ca_cert"; then
    echo "Generating CA's private key and certificate..."
      # Delete the old key and the certificate if they exist
    rm -f "$ca_key" "$ca_cert"
    openssl req -x509 -nodes -days 3650 -newkey rsa:4096 \
      -keyout "$ca_key" \
      -out "$ca_cert" \
      -config "$ca_config_file" || { echo "Failed to generate CA's private key and certificate."; exit 1; }
else
    echo "CA's private key and certificate already exist and are up to date."
fi

# Generate the Nginx server's private key if it doesn't exist
if [ ! -f "$server_key" ]; then
    echo "Generating Nginx server's private key..."
    openssl genrsa -out "$server_key" 2048 || { echo "Failed to generate Nginx server's private key."; exit 1; }
else
    echo "Nginx server's private key already exists."
fi

# Always generate a new CSR and sign it
echo "Generating Nginx server's CSR..."
openssl req -new -key "$server_key" \
  -out "$server_csr" \
  -config "$server_config_file" || { echo "Failed to generate Nginx server's CSR."; exit 1; }

echo "Signing Nginx server's CSR with the CA's private key and certificate..."
openssl x509 -req -days 365 \
  -in "$server_csr" \
  -CA "$ca_cert" \
  -CAkey "$ca_key" \
  -CAcreateserial \
  -out "$server_cert" \
  -extfile "$server_config_file" \
  -extensions v3_req || { echo "Failed to sign Nginx server's CSR."; exit 1; }

# Cleanup CSR and serial file (if it exists)
rm "$server_csr"
if [ -f "$nginx_cert_dir/site-ca.srl" ]; then
    rm "$nginx_cert_dir/site-ca.srl"
fi

echo "Certificates generated successfully."
