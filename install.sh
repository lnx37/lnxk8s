#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source env.sh
echo "${ETCD_IP_LIST[@]}"
echo "${MASTER_IP_LIST[@]}"
echo "${WORKER_IP_LIST[@]}"
echo "${NETWORK_PLUGIN}"

# ---

bash install_kubectl.sh

# ---

for ETCD_IP in "${ETCD_IP_LIST[@]}"; do
  bash install_etcd.sh "${ETCD_IP}"
done

# ---

# bash install_kubernetes_master.sh "${MASTER_IP}"
for MASTER_IP in "${MASTER_IP_LIST[@]}"; do
  bash install_kubernetes_common.sh "${MASTER_IP}"
  bash install_kubernetes_kubectl.sh "${MASTER_IP}"
  bash install_kubernetes_kube_apiserver.sh "${MASTER_IP}"
  bash install_kubernetes_kube_controller_manager.sh "${MASTER_IP}"
  bash install_kubernetes_kube_scheduler.sh "${MASTER_IP}"
done

# ---

# bash install_kubernetes_worker.sh "${WORKER_IP}"
for WORKER_IP in "${WORKER_IP_LIST[@]}"; do
  bash install_cni_plugins.sh "${WORKER_IP}"

  if [ "${CONTAINER_RUNTIME}" = "containerd" ]; then
    bash install_containerd.sh "${WORKER_IP}"
    bash install_runc.sh "${WORKER_IP}"
    bash install_crictl.sh "${WORKER_IP}"
  fi
  if [ "${CONTAINER_RUNTIME}" = "crio" ]; then
    bash install_crio.sh "${WORKER_IP}"
  fi
  if [ "${CONTAINER_RUNTIME}" = "docker" ]; then
    bash install_docker.sh "${WORKER_IP}"
    bash install_cri_dockerd.sh "${WORKER_IP}"
  fi

  bash install_kubernetes_common.sh "${WORKER_IP}"
  bash install_kubernetes_kubelet.sh "${WORKER_IP}"
  bash install_kubernetes_kube_proxy.sh "${WORKER_IP}"
done

# ---

if [ "${NETWORK_PLUGIN}" = "calico" ]; then
  bash addon/calico/install_calico.sh
fi
if [ "${NETWORK_PLUGIN}" = "cilium" ]; then
  bash tool/helm/install_helm.sh
  bash addon/cilium/install_cilium.sh
fi
if [ "${NETWORK_PLUGIN}" = "flannel" ]; then
  bash addon/flannel/install_flannel.sh
fi

# ---

bash addon/coredns/install_coredns.sh

bash addon/metrics_server/install_metrics_server.sh

date
