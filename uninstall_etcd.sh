#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source env.sh
echo "${ETCD_IP_LIST[@]}"

for ETCD_IP in "${ETCD_IP_LIST[@]}"; do
  scp -p script/uninstall_etcd.sh root@"${ETCD_IP}":/tmp/
  ssh root@"${ETCD_IP}" "bash /tmp/uninstall_etcd.sh"
done

date
