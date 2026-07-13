#!/usr/bin/env bash

SUBJECT_POUR_CLIENT="/C=FR/ST=Paris/L=Paris/O=CompanyName/OU=CompanySectionName/CN=localhost"

genere_certificat_serveur() {
  clef_serveur="$1"
  certificat_serveur="$2"
  pem_serveur="$3"
  domaine="${4:-localhost}"

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
    -subj "/C=FR/ST=Paris/L=Paris/O=CompanyName/OU=CompanySectionName/CN=$domaine"

  cat "$clef_serveur" "$certificat_serveur" > "$pem_serveur"
  chmod 600 "$pem_serveur"
}

genere_authorite_de_certification() {
  certificat_ac="$1"
  clef_ac="$2"

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
    -subj "$SUBJECT_POUR_CLIENT"
}

signe_certificat_client() {
  certificat_ac="$1"
  clef_ac="$2"
  requete_client="$3"
  certificat_client_signe="$4"

  openssl req \
    -x509 \
    -in "$requete_client" \
    -CA "$certificat_ac" \
    -CAkey "$clef_ac" \
    -out "$certificat_client_signe" \
    -nodes \
    -days 365 \
    -subj "$SUBJECT_POUR_CLIENT"
}
