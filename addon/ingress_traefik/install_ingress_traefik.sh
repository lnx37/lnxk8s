#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

helm repo add traefik https://traefik.github.io/charts
# helm install traefik traefik/traefik
helm install traefik traefik/traefik -f yml/value.yml

date
