#!/usr/bin/env bash

# shellcheck source=tls.sh
source ../tls.sh

teardown() {
  rm {.,..}/*.{crt,key,pem} 2>/dev/null
}

test_peut_generer_un_certificat_serveur_avec_un_commonName_par_defaut() {
  certificat=ca.crt
  genere_certificat_serveur ca.key "$certificat" ca.pem

  nom_attendu="localhost"
  nom_reel="$(openssl x509 -in "$certificat" -noout -subject -nameopt multiline | grep commonName | cut -d'=' -f2 | tr -d ' ')"

  assert_equals "$nom_attendu" "$nom_reel"
}

test_peut_generer_un_certificat_serveur_avec_un_commonName_specifique() {
  domaine="truc.cleverapps.io"
  certificat=ca.crt
  genere_certificat_serveur ca.key "$certificat" ca.pem "$domaine"

  nom_reel="$(openssl x509 -in "$certificat" -noout -subject -nameopt multiline | grep commonName | cut -d'=' -f2 | tr -d ' ')"

  assert_equals "$domaine" "$nom_reel"
}
