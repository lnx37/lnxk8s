#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

diff \
  -r \
  -u \
  --exclude="pki" \
  --exclude="collect.sh" \
  --exclude="admin.conf" \
  --exclude="controller-manager.conf" \
  --exclude="kubelet.conf" \
  --exclude="scheduler.conf" \
  --exclude="kubectl-kubeconfig.conf" \
  kubeadm129 kubeadm130

date
