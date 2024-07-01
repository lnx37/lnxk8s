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

for MASTER_IP in "${MASTER_IP_LIST[@]}"; do
  ssh root@"${MASTER_IP}" "systemctl status kube-apiserver"
done

for MASTER_IP in "${MASTER_IP_LIST[@]}"; do
  ssh root@"${MASTER_IP}" "systemctl status kube-controller-manager"
done

for MASTER_IP in "${MASTER_IP_LIST[@]}"; do
  ssh root@"${MASTER_IP}" "systemctl status kube-scheduler"
done

for WORKER_IP in "${WORKER_IP_LIST[@]}"; do
  ssh root@"${WORKER_IP}" "systemctl status kubelet"
done

for WORKER_IP in "${WORKER_IP_LIST[@]}"; do
  ssh root@"${WORKER_IP}" "systemctl status kube-proxy"
done

for MASTER_IP in "${MASTER_IP_LIST[@]}"; do
  ssh root@"${MASTER_IP}" "kubectl get all"
done

date
