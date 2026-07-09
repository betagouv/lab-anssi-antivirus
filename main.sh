#!/usr/bin/env bash

CLAMD_PORT="3310"
CLAMD_ADRESSE="127.0.0.1"
PORT_A_EXPOSER="4040"

source "$(dirname "${BASH_SOURCE[0]}")/tls.sh"

run() {
  authorite_de_certification="$1"

  echo "genere le certificat du serveur..."
  genere_certificat_serveur

  echo "expose \`clamd\` via TLS..."
  socat 2>/dev/null \
    "OPENSSL-LISTEN:$PORT_A_EXPOSER,cert=$pem_serveur,cafile=$authorite_de_certification,verify=1,fork" \
    "TCP:${CLAMD_ADRESSE}:${CLAMD_PORT}" \
    &
}
