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

source env.sh
echo "${CONTAINER_RUNTIME}"

bash install_cni_plugins.sh "${WORKER_IP}"

if [ "${CONTAINER_RUNTIME}" = "containerd" ]; then
  bash install_containerd.sh "${WORKER_IP}"
  bash install_runc.sh "${WORKER_IP}"
  bash install_crictl.sh "${WORKER_IP}"
fi
if [ "${CONTAINER_RUNTIME}" = "docker" ]; then
  bash install_docker.sh "${WORKER_IP}"
  bash install_cri_dockerd.sh "${WORKER_IP}"
fi

bash install_kubernetes_common.sh "${WORKER_IP}"
bash install_kubernetes_kubelet.sh "${WORKER_IP}"
bash install_kubernetes_kube_proxy.sh "${WORKER_IP}"

date
