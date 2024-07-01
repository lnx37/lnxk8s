#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

# kubectl get pods -A |grep "traefik"
# kubectl get services -A |grep "traefik"
# kubectl get deployments -A |grep "traefik"

kubectl get all -A |grep "traefik"

date
