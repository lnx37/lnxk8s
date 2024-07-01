#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg

cd pkg

# https://github.com/containerd/containerd
# https://github.com/containerd/containerd/releases
#
# https://github.com/containerd/containerd/releases/download/v1.6.28/containerd-1.6.28-linux-amd64.tar.gz
# https://github.com/containerd/containerd/releases/download/v1.6.28/cri-containerd-cni-1.6.28-linux-amd64.tar.gz
#
# wget -c "https://github.com/containerd/containerd/releases/download/v1.6.28/containerd-1.6.28-linux-amd64.tar.gz" -O containerd-1.6.28-linux-amd64.tar.gz
# wget -c "http://199.115.230.237:12345/kubernetes/containerd-1.6.28-linux-amd64.tar.gz" -O containerd-1.6.28-linux-amd64.tar.gz
wget -c "http://199.115.230.237:12345/kubernetes/containerd-1.6.28-linux-amd64.tar.gz" -O containerd-1.6.28-linux-amd64.tar.gz

date
