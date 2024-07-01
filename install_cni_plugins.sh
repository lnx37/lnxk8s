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

ssh root@"${WORKER_IP}" "bash /opt/artifact/install_cni_plugins.sh"

date
