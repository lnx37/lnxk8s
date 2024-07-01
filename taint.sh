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

kubectl describe node |grep -E "^Name:|^Roles:|^Taints:"

if [ "${#WORKER_IP_LIST[@]}" -gt "${#MASTER_IP_LIST[@]}" ]; then
  for MASTER_IP in "${MASTER_IP_LIST[@]}"; do
    hostname="$(ssh root@"${MASTER_IP}" "hostname" 2>/dev/null)"
    hostname=$(echo "$hostname" |tr '[:upper:]' '[:lower:]')

    # kubectl taint node "$hostname" node-role.kubernetes.io/master=:NoSchedule --overwrite
    kubectl taint node "$hostname" node-role.kubernetes.io/control-plane=:NoSchedule --overwrite

    # kubectl label node "$hostname" node-role.kubernetes.io/master=master --overwrite
    kubectl label node "$hostname" node-role.kubernetes.io/control-plane=control-plane --overwrite
  done
fi

kubectl describe node |grep -E "^Name:|^Roles:|^Taints:"

date
