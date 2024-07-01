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
  bash unpkg_cfssl.sh
  bash unpkg_etcd.sh
  bash unpkg_cni_plugins.sh
  if [ "${CONTAINER_RUNTIME}" = "containerd" ]; then
    bash unpkg_containerd.sh
    bash unpkg_runc.sh
    bash unpkg_crictl.sh
  fi
  if [ "${CONTAINER_RUNTIME}" = "crio" ]; then
    bash unpkg_crio.sh
  fi
  if [ "${CONTAINER_RUNTIME}" = "docker" ]; then
    bash unpkg_docker.sh
    bash unpkg_cri_dockerd.sh
  fi
  bash unpkg_kubernetes.sh
fi

if [ "${OS_ARCH}" = "arm64" ]; then
  bash unpkg_cfssl_arm64.sh
  bash unpkg_etcd_arm64.sh
  bash unpkg_cni_plugins_arm64.sh
  if [ "${CONTAINER_RUNTIME}" = "containerd" ]; then
    bash unpkg_containerd_arm64.sh
    bash unpkg_runc_arm64.sh
    bash unpkg_crictl_arm64.sh
  fi
  if [ "${CONTAINER_RUNTIME}" = "crio" ]; then
    bash unpkg_crio_arm64.sh
  fi
  if [ "${CONTAINER_RUNTIME}" = "docker" ]; then
    bash unpkg_docker_arm64.sh
    bash unpkg_cri_dockerd_arm64.sh
  fi
  bash unpkg_kubernetes_arm64.sh
fi

date
