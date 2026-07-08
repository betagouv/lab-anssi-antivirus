source ./fixtures/clamd.sh

setup() {
  simule_clamd
}

teardown() {
  nettoie_clamd_simulation
}

test_peut_envoyer_un_message_a_clamd() {
  message="foo"
  echo "$message" | nc -N 127.0.0.1 3310

  assert "grep $message $clamd_recu"
}
