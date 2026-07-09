#!/usr/bin/env bash

genere_certificat_serveur() {
  clef_serveur=s.key
  certificat_serveur=s.crt
  pem_serveur=s.pem

  openssl genpkey 2>/dev/null \
    -algorithm RSA \
    -pkeyopt rsa_keygen_bits:2048 \
    -out "$clef_serveur"

  openssl req >/dev/null \
    -quiet \
    -new \
    -x509 \
    -key "$clef_serveur" \
    -out "$certificat_serveur" \
    -days 365 \
    -subj "/C=FR/ST=Paris/L=Paris/O=CompanyName/OU=CompanySectionName/CN=localhost"

  cat "$clef_serveur" "$certificat_serveur" > "$pem_serveur"
  chmod 600 "$pem_serveur"

  export pem_serveur
}
