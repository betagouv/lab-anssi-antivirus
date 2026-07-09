#!/usr/bin/env bash

SUBJECT="/C=FR/ST=Paris/L=Paris/O=CompanyName/OU=CompanySectionName/CN=localhost"

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
    -subj "$SUBJECT"

  cat "$clef_serveur" "$certificat_serveur" > "$pem_serveur"
  chmod 600 "$pem_serveur"

  export pem_serveur
}

genere_authorite_de_certification() {
  certificat_ac=ca.crt
  clef_ac=ca.key

  openssl genpkey 2>/dev/null \
    -algorithm RSA \
    -pkeyopt rsa_keygen_bits:2048 \
    -out "$clef_ac"

  openssl req \
    -quiet \
    -new \
    -x509 \
    -key "$clef_ac" \
    -out "$certificat_ac" \
    -days 365 \
    -subj "$SUBJECT"

  export certificat_ac
}

signe_certificat_client() {
  certificat_client="$1"
  certificat_client_signe=client.crt

  openssl req \
    -x509 \
    -in "$certificat_client" \
    -CA "$certificat_ac" \
    -CAkey "$clef_ac" \
    -out "$certificat_client_signe" \
    -nodes \
    -days 365 \
    -subj "$SUBJECT"

  export certificat_client_signe
}
