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

for ETCD_IP in "${ETCD_IP_LIST[@]}"; do
  bash make_etcd.sh "${ETCD_IP}"
done

if [ "${CONTAINER_RUNTIME}" = "containerd" ]; then
  bash make_containerd.sh
  bash make_crictl.sh
fi
if [ "${CONTAINER_RUNTIME}" = "crio" ]; then
  bash make_crio.sh
fi
if [ "${CONTAINER_RUNTIME}" = "docker" ]; then
  bash make_docker.sh
  bash make_cri_dockerd.sh
fi

bash make_kubernetes_common.sh
bash make_kubernetes_kubectl.sh
bash make_kubernetes_kube_apiserver.sh
bash make_kubernetes_kube_controller_manager.sh
bash make_kubernetes_kube_scheduler.sh
bash make_kubernetes_kubelet.sh
bash make_kubernetes_kube_proxy.sh

date
