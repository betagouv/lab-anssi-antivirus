simule_clamd() {
  clamd_recu="$(mktemp)"

  socat TCP-LISTEN:3310,reuseaddr,fork FILE:"$clamd_recu" 2>/dev/null &
  clamd_id="$!"

  export clamd_id
  export clamd_recu
}

nettoie_clamd_simulation() {
  kill "$clamd_id"
  rm "$clamd_recu"
}
