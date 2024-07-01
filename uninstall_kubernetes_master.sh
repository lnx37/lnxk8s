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

scp -p script/uninstall_kubernetes_master.sh root@"${MASTER_IP}":/tmp/
ssh root@"${MASTER_IP}" "bash /tmp/uninstall_kubernetes_master.sh"

date
