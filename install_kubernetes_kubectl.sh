#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

[ "$#" -ne 1 ] && echo "invalid argument, need an ip" && exit 1

MASTER_IP="$1"
echo "${MASTER_IP}"

ssh root@"${MASTER_IP}" "bash /opt/artifact/install_kubernetes_kubectl.sh"

date
