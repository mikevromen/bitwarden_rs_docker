#!/bin/bash

function ext()
{
    cat << EOF 
        authorityKeyIdentifier=keyid,issuer\n
        basicConstraints=CA:FALSE\n
        keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment\n
        extendedKeyUsage = serverAuth\n
        subjectAltName = @alt_names\n
        [alt_names]\n
        IP.1 = $1
EOF
}

openssl genpkey -algorithm RSA -aes128 -out private-ca.key -outform PEM -pkeyopt rsa_keygen_bits:2048
openssl req -x509 -new -nodes -sha256 -days 3650 -key private-ca.key -out self-signed-ca-cert.crt
openssl genpkey -algorithm RSA -out bitwarden.key -outform PEM -pkeyopt rsa_keygen_bits:2048
openssl req -new -key bitwarden.key -out bitwarden.csr
openssl x509 -req -in bitwarden.csr -CA self-signed-ca-cert.crt -CAkey private-ca.key -CAcreateserial -out bitwarden.crt -days 365 -sha256 -extfile <(printf "$ext")

echo "creating dirs and moving certs"
mkdir ssl
mv bitwarden.crt bitwarden.key ssl/

printf "\\nEverything should be good to go. \\nYou might want to change some variables like backup time in the docker-compose file.\\n"
printf "Run \"docker-compose up -d\" command to start the containers"