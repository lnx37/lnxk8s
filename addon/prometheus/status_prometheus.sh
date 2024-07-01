#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

kubectl get all -n monitoring

kubectl get pod -n monitoring -o wide

date
