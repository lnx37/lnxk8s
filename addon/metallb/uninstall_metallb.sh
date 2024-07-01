#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

kubectl delete -f yml/metallb_ip_pool.yml

kubectl delete -f yml/metallb-native.yaml

date
