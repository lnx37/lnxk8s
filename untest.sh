#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

kubectl delete deployment.apps/busybox

kubectl delete deployment.apps/nginx service/nginx

date
