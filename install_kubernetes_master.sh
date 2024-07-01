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

bash install_kubernetes_common.sh "${MASTER_IP}"
bash install_kubernetes_kubectl.sh "${MASTER_IP}"
bash install_kubernetes_kube_apiserver.sh "${MASTER_IP}"
bash install_kubernetes_kube_controller_manager.sh "${MASTER_IP}"
bash install_kubernetes_kube_scheduler.sh "${MASTER_IP}"

date
