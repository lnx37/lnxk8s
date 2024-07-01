#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg
mkdir -p artifact/containerd

cd pkg

# wget -c "https://github.com/containerd/containerd/releases/download/v1.6.28/containerd-1.6.28-linux-arm64.tar.gz" -O containerd-1.6.28-linux-arm64.tar.gz
# wget -c "http://199.115.230.237:12345/kubernetes/containerd-1.6.28-linux-arm64.tar.gz" -O containerd-1.6.28-linux-arm64.tar.gz

[ -d containerd ] && rm -rf containerd
mkdir -p containerd
tar xzf containerd-1.6.28-linux-arm64.tar.gz -C containerd

chown -R root:root containerd

chmod +x containerd/bin/containerd
chmod +x containerd/bin/containerd-shim
chmod +x containerd/bin/containerd-shim-runc-v1
chmod +x containerd/bin/containerd-shim-runc-v2
chmod +x containerd/bin/containerd-stress
chmod +x containerd/bin/ctr

cp -a containerd/bin/containerd              ../artifact/containerd/containerd
cp -a containerd/bin/containerd-shim         ../artifact/containerd/containerd-shim
cp -a containerd/bin/containerd-shim-runc-v1 ../artifact/containerd/containerd-shim-runc-v1
cp -a containerd/bin/containerd-shim-runc-v2 ../artifact/containerd/containerd-shim-runc-v2
cp -a containerd/bin/containerd-stress       ../artifact/containerd/containerd-stress
cp -a containerd/bin/ctr                     ../artifact/containerd/ctr

date
