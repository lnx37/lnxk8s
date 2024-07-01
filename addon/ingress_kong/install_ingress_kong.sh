#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

helm repo add kong https://charts.konghq.com
helm install kong kong/ingress -n kong --create-namespace

date
