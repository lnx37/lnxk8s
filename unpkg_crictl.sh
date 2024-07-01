#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg
mkdir -p artifact/crictl

cd pkg

# wget -c "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.28.0/crictl-v1.28.0-linux-amd64.tar.gz" -O crictl-v1.28.0-linux-amd64.tar.gz
# wget -c "http://199.115.230.237:12345/kubernetes/crictl-v1.28.0-linux-amd64.tar.gz" -O crictl-v1.28.0-linux-amd64.tar.gz

[ -d crictl ] && rm -rf crictl
mkdir -p crictl
tar xzf crictl-v1.28.0-linux-amd64.tar.gz -C crictl

chown -R root:root crictl

chmod +x crictl/crictl

cp -a crictl/crictl ../artifact/crictl/crictl

date
