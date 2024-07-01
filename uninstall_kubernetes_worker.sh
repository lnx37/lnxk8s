#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

[ "$#" -ne 1 ] && echo "invalid argument, need an ip" && exit 1

WORKER_IP="$1"
echo "${WORKER_IP}"

scp -p script/uninstall_kubernetes_worker.sh root@"${WORKER_IP}":/tmp/
ssh root@"${WORKER_IP}" "bash /tmp/uninstall_kubernetes_worker.sh"

date
