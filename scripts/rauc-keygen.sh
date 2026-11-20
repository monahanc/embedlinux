#!/usr/bin/env bash
set -euo pipefail

DEST="$(cd "$(dirname "$0")/.." && pwd)/meta-embedlinux/recipes-core/rauc/files"

if [[ -f "$DEST/ca.cert.pem" && -f "$DEST/development-1.cert.pem" && -f "$DEST/development-1.key.pem" && "${1:-}" != "--force" ]]; then
    echo "RAUC dev keys already exist in $DEST (pass --force to regenerate)."
    exit 0
fi

TMPCA="$(mktemp -d)"
trap 'rm -rf "$TMPCA"' EXIT

mkdir -p "$TMPCA/dev/private" "$TMPCA/dev/certs"
touch "$TMPCA/dev/index.txt"
echo 01 > "$TMPCA/dev/serial"

cat > "$TMPCA/openssl.cnf" <<'EOF'
[ ca ]
default_ca      = CA_default

[ CA_default ]
dir             = .
database        = $dir/index.txt
new_certs_dir   = $dir/certs
certificate     = $dir/ca.cert.pem
serial          = $dir/serial
private_key     = $dir/private/ca.key.pem
RANDFILE        = $dir/private/.rand

default_startdate = 19700101000000Z
default_enddate   = 99991231235959Z
default_crl_days  = 30
default_md        = sha256

policy          = policy_any
email_in_dn     = no
name_opt        = ca_default
cert_opt        = ca_default
copy_extensions = none

[ policy_any ]
organizationName = match
commonName       = supplied

[ req ]
default_bits       = 2048
distinguished_name = req_distinguished_name
x509_extensions    = v3_leaf
encrypt_key        = no
default_md         = sha256

[ req_distinguished_name ]
commonName     = Common Name
commonName_max = 64

[ v3_ca ]
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid:always,issuer:always
basicConstraints       = CA:TRUE

[ v3_leaf ]
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid:always,issuer:always
basicConstraints       = CA:FALSE
EOF

export OPENSSL_CONF="$TMPCA/openssl.cnf"
cd "$TMPCA/dev"

openssl req -newkey rsa:2048 -keyout private/ca.key.pem -out ca.csr.pem \
    -subj "/O=EmbedLinux/CN=EmbedLinux RAUC Development CA"
openssl ca -batch -selfsign -extensions v3_ca -in ca.csr.pem -out ca.cert.pem \
    -keyfile private/ca.key.pem

openssl req -newkey rsa:2048 -keyout private/development-1.key.pem -out development-1.csr.pem \
    -subj "/O=EmbedLinux/CN=EmbedLinux Development-1"
openssl ca -batch -extensions v3_leaf -in development-1.csr.pem -out development-1.cert.pem

mkdir -p "$DEST"
cp ca.cert.pem "$DEST/ca.cert.pem"
cp development-1.cert.pem "$DEST/development-1.cert.pem"
cp private/development-1.key.pem "$DEST/development-1.key.pem"
chmod 600 "$DEST/development-1.key.pem"

echo "Generated RAUC dev CA and signing keys in $DEST"
