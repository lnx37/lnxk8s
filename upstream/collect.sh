#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

bash kubeadm128/collect.sh

bash kubeadm129/collect.sh

bash kubeadm130/collect.sh

date
