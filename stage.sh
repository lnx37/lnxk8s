#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source env.sh
echo "${CONTAINER_RUNTIME}"
echo "${ETCD_IP_LIST[@]}"

# ---

bash stage_kubectl.sh

for ETCD_IP in "${ETCD_IP_LIST[@]}"; do
  bash stage_etcd.sh "${ETCD_IP}"
done

# ---

bash stage_kubernetes_common.sh
bash stage_kubernetes_kubectl.sh
bash stage_kubernetes_kube_apiserver.sh
bash stage_kubernetes_kube_controller_manager.sh
bash stage_kubernetes_kube_scheduler.sh

# ---

bash stage_cni_plugins.sh

if [ "${CONTAINER_RUNTIME}" = "containerd" ]; then
  bash stage_containerd.sh
  bash stage_runc.sh
  bash stage_crictl.sh
fi
if [ "${CONTAINER_RUNTIME}" = "crio" ]; then
  bash stage_crio.sh
fi
if [ "${CONTAINER_RUNTIME}" = "docker" ]; then
  bash stage_docker.sh
  bash stage_cri_dockerd.sh
fi

bash stage_kubernetes_common.sh
bash stage_kubernetes_kubelet.sh
bash stage_kubernetes_kube_proxy.sh

date
