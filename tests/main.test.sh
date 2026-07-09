#!/usr/bin/env bash

# shellcheck source=main.sh
source ../main.sh
# shellcheck source=tests/fixtures/clamd.sh
source ./fixtures/clamd.sh

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
