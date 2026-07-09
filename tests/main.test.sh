#!/usr/bin/env bash

# shellcheck source=main.sh
source ../main.sh
# shellcheck source=tls.sh
source ../tls.sh
# shellcheck source=tests/fixtures/clamd.sh
source ./fixtures/clamd.sh
# shellcheck source=tests/fixtures/tls.sh
source ./fixtures/tls.sh

setup() {
  simule_clamd
}

teardown() {
  nettoie_clamd_simulation

  pgrep -f "socat OPENSSL-LISTEN:" | xargs --no-run-if-empty kill
}

test_peut_envoyer_un_message_a_clamd() {
  message="foo"
  echo "$message" | nc -N 127.0.0.1 3310

  assert "grep $message $clamd_recu"
}

test_un_client_sans_certificat_ne_peut_pas_parler_avec_clamd() {
  run >/dev/null &
  sleep 0.2

  message="foo"
  echo "foo" | openssl s_client -quiet -no_ign_eof -noservername -connect 127.0.0.1:4040 2>/dev/null

  assert_fail "grep $message $clamd_recu"
}

test_un_client_avec_un_bon_certificat_peut_parler_avec_clamd() {
  genere_authorite_de_certification ca.crt ca.key
  genere_demande_de_signature_de_certificat_client client.key client.csr
  signe_certificat_client ca.crt ca.key client.csr client.crt

  run ca.crt >/dev/null &
  sleep 0.2

  message="foo"
  echo "foo" | openssl s_client -key client.key -cert client.crt -quiet -no_ign_eof -noservername -connect 127.0.0.1:4040 2>/dev/null

  assert "grep $message $clamd_recu"
}
