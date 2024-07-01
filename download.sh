#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source env.sh
echo "${CONTAINER_RUNTIME}"
echo "${OS_ARCH}"

if [ "${OS_ARCH}" = "amd64" ]; then
  bash download_cfssl.sh
  bash download_etcd.sh
  bash download_cni_plugins.sh
  if [ "${CONTAINER_RUNTIME}" = "containerd" ]; then
    bash download_containerd.sh
    bash download_runc.sh
    bash download_crictl.sh
  fi
  if [ "${CONTAINER_RUNTIME}" = "crio" ]; then
    bash download_crio.sh
  fi
  if [ "${CONTAINER_RUNTIME}" = "docker" ]; then
    bash download_docker.sh
    bash download_cri_dockerd.sh
  fi
  bash download_kubernetes.sh
fi

if [ "${OS_ARCH}" = "arm64" ]; then
  bash download_cfssl_arm64.sh
  bash download_etcd_arm64.sh
  bash download_cni_plugins_arm64.sh
  if [ "${CONTAINER_RUNTIME}" = "containerd" ]; then
    bash download_containerd_arm64.sh
    bash download_runc_arm64.sh
    bash download_crictl_arm64.sh
  fi
  if [ "${CONTAINER_RUNTIME}" = "crio" ]; then
    bash download_crio_arm64.sh
  fi
  if [ "${CONTAINER_RUNTIME}" = "docker" ]; then
    bash download_docker_arm64.sh
    bash download_cri_dockerd_arm64.sh
  fi
  bash download_kubernetes_arm64.sh
fi

date
