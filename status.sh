#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

kubectl get ns

echo

kubectl get node -o wide

echo

kubectl get pod -A -o wide

echo

kubectl get svc -A

echo

kubectl get deploy -A

date
