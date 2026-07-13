#!/usr/bin/env bash

source ./main.sh

echo "$CA_CRT" > ca.crt
run ca.crt

# Nécessaire pour que la plateforme pense qu'une application tourne.
python3 -m http.server 8080
