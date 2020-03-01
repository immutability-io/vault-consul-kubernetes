#!/bin/sh

set -ex

function gencerts {

	cat > "./openssl.cnf" << EOF
[req]
default_bits = 2048
encrypt_key  = no
default_md   = sha256
prompt       = no
utf8         = yes

# Speify the DN here so we aren't prompted (along with prompt = no above).
distinguished_name = req_distinguished_name

# Extensions for SAN IP and SAN DNS
req_extensions = v3_req

# Be sure to update the subject to match your organization.
[req_distinguished_name]
C  = TH
ST = Bangkok
L  = Vault
O  = omiseGO
CN = localhost

# Allow client and server auth. You may want to only allow server auth.
# Link to SAN names.
[v3_req]
basicConstraints     = CA:FALSE
subjectKeyIdentifier = hash
keyUsage             = digitalSignature, keyEncipherment
extendedKeyUsage     = clientAuth, serverAuth
subjectAltName       = @alt_names

# Alternative names are specified as IP.# and DNS.# for IPs and
# DNS accordingly.
[alt_names]
IP.1  = 127.0.0.1
IP.2  = 127.0.0.2
IP.3  = 127.0.0.3
IP.4  = 127.0.0.4
IP.5  = 192.168.64.1
DNS.1 = localhost
EOF

	openssl req \
	-new \
	-sha256 \
	-newkey rsa:2048 \
	-days 120 \
	-nodes \
	-x509 \
	-subj "/C=US/ST=Maryland/L=Vault/O=My Company CA" \
	-keyout "root.key" \
	-out "root.crt"

	# Generate the private key for the service. Again, you may want to increase
	# the bits to 2048.
	openssl genrsa -out "vault.key" 2048

	# Generate a CSR using the configuration and the key just generated. We will
	# give this CSR to our CA to sign.
	openssl req \
	-new -key "vault.key" \
	-out "vault.csr" \
	-config "openssl.cnf"

	# Sign the CSR with our CA. This will generate a new certificate that is signed
	# by our CA.
	openssl x509 \
	-req \
	-days 120 \
	-in "vault.csr" \
	-CA "root.crt" \
	-CAkey "root.key" \
	-CAcreateserial \
	-sha256 \
	-extensions v3_req \
	-extfile "openssl.cnf" \
	-out "vault.crt"

	openssl x509 -in "vault.crt" -noout -text

	rm openssl.cnf

  
}

gencerts