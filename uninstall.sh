#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source env.sh
echo "${MASTER_IP_LIST[@]}"
echo "${WORKER_IP_LIST[@]}"

bash uninstall_common.sh

bash uninstall_etcd.sh

for MASTER_IP in "${MASTER_IP_LIST[@]}"; do
  bash uninstall_kubernetes_master.sh "${MASTER_IP}"
done

for WORKER_IP in "${WORKER_IP_LIST[@]}"; do
  bash uninstall_kubernetes_worker.sh "${WORKER_IP}"
done

bash uninstall_misc.sh

date
