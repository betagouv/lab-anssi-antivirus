#!/usr/bin/env bash

# shellcheck source=tls.sh
source ../tls.sh

genere_demande_de_signature_de_certificat_client() {
  clef_client="$1"
  demande_de_signature_de_certificat_client="$2"

  openssl genpkey 2>/dev/null \
    -algorithm RSA \
    -pkeyopt rsa_keygen_bits:2048 \
    -out "$clef_client"

  openssl req \
    -new \
    -key "$clef_client" \
    -out "$demande_de_signature_de_certificat_client" \
    -subj "$SUBJECT"
}
