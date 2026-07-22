#!/usr/bin/env bash

# shellcheck source=main.sh
source ../main.sh
# shellcheck source=tls.sh
source ../tls.sh
# shellcheck source=tests/fixtures/clamd.sh
source ./fixtures/clamd.sh
# shellcheck source=tests/fixtures/tls.sh
source ./fixtures/tls.sh

# Pour éviter des soucis de concurrence,
# on a besoin d'un petit délai au démarrage de la plomberie qui expose `clamav` en TLS avant de communiquer avec.
DELAI=0.1

openssl_client() {
  openssl s_client -quiet -no_ign_eof -noservername -connect 127.0.0.1:4040 $@ 2>/dev/null
}

setup() {
  simule_clamd
}

teardown() {
  nettoie_clamd_simulation

  pkill -f "socat -r .* OPENSSL-LISTEN:"

  rm {.,..}/*.{crt,key,pem} 2>/dev/null
  rm --force socat.in.log
}

test_peut_envoyer_un_message_a_clamd() {
  message="foo"
  echo "$message" | nc -N 127.0.0.1 3310

  assert "grep $message $clamd_recu"
}

test_un_client_sans_certificat_ne_peut_pas_parler_avec_clamd() {
  run ca.crt "domaine.fr" socat.in.log >/dev/null &
  sleep "$DELAI"

  message="foo"
  echo "$message" | openssl_client

  assert_fail "grep $message $clamd_recu"
}

test_un_client_avec_un_bon_certificat_peut_parler_avec_clamd() {
  genere_authorite_de_certification ca.crt ca.key
  genere_demande_de_signature_de_certificat_client client.key client.csr
  signe_certificat_client ca.crt ca.key client.csr client.crt 2>/dev/null

  run ca.crt "domaine.fr" socat.in.log >/dev/null &
  sleep "$DELAI"

  message="foo"
  echo "$message" | openssl_client -key client.key -cert client.crt

  assert "grep $message $clamd_recu"
}

test_un_client_avec_un_mauvais_certificat_ne_peut_pas_parler_avec_clamd() {
  genere_authorite_de_certification ca.bon.crt ca.bon.key
  genere_authorite_de_certification ca.mauvais.crt ca.mauvais.key

  genere_demande_de_signature_de_certificat_client client.key client.csr
  signe_certificat_client ca.mauvais.crt ca.mauvais.key client.csr client.crt 2>/dev/null

  run ca.bon.crt "domaine.fr" socat.in.log >/dev/null &
  sleep "$DELAI"

  message="foo"
  echo "$message" | openssl_client -key client.key -cert client.crt

  assert_fail "grep $message $clamd_recu"
}

test_peut_etre_lance_pour_etre_expose_sur_un_domaine_precis() {
  genere_authorite_de_certification ca.crt ca.key
  domaine="truc.cleverapps.io"

  run ca.crt "$domaine" socat.in.log >/dev/null &
  sleep "$DELAI"

  domaine_du_certificat="$(extrait_commonName <(openssl s_client -connect 127.0.0.1:4040 2>/dev/null))"

  assert_equals "$domaine" "$domaine_du_certificat"
}

test_journalise_les_informations_recues () {
  genere_authorite_de_certification ca.crt ca.key
  genere_demande_de_signature_de_certificat_client client.key client.csr
  signe_certificat_client ca.crt ca.key client.csr client.crt 2>/dev/null

  run ca.crt "domaine.fr" socat.in.log >/dev/null &
  sleep "$DELAI"

  message="foo"
  echo "$message" | openssl_client -key client.key -cert client.crt

  assert "grep $message socat.in.log"
}
