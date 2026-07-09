#!/usr/bin/env bash

CLAMD_PORT="3310"
CLAMD_ADRESSE="127.0.0.1"
PORT_A_EXPOSER="4040"

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

run() {
  echo "genere le certificat du serveur..."
  genere_certificat_serveur
  echo "expose \`clamd\` via TLS..."
  socat 2>/dev/null \
    "OPENSSL-LISTEN:$PORT_A_EXPOSER,cert=$pem_serveur,verify=0,fork" \
    "TCP:${CLAMD_ADRESSE}:${CLAMD_PORT}" \
    &
}
