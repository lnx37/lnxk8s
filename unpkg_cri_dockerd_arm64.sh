#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg
mkdir -p artifact/cri-dockerd

cd pkg

# wget -c "https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.9/cri-dockerd-0.3.9.arm64.tgz" -O cri-dockerd-0.3.9.arm64.tgz
# wget -c "http://199.115.230.237:12345/kubernetes/cri-dockerd-0.3.9.arm64.tgz" -O cri-dockerd-0.3.9.arm64.tgz

[ -d cri-dockerd ] && rm -rf cri-dockerd
tar xzf cri-dockerd-0.3.9.arm64.tgz

chown -R root:root cri-dockerd

chmod +x cri-dockerd/cri-dockerd

cp -a cri-dockerd/cri-dockerd ../artifact/cri-dockerd/cri-dockerd

date
