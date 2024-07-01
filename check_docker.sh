#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source env.sh
echo "${WORKER_IP_LIST[@]}"

for WORKER_IP in "${WORKER_IP_LIST[@]}"; do
  ssh root@"${WORKER_IP}" "docker images"
done

date
