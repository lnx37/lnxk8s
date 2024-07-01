#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source env.sh
echo "${CONTAINER_RUNTIME}"

bash check_etcd.sh

if [ "${CONTAINER_RUNTIME}" = "containerd" ]; then
  bash check_containerd.sh
fi
if [ "${CONTAINER_RUNTIME}" = "crio" ]; then
  bash check_crio.sh
fi
if [ "${CONTAINER_RUNTIME}" = "docker" ]; then
  bash check_docker.sh
fi

bash check_kubernetes.sh

date
