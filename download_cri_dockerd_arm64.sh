#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg

cd pkg

# https://github.com/Mirantis/cri-dockerd
# https://github.com/Mirantis/cri-dockerd/releases
#
# wget -c "https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.9/cri-dockerd-0.3.9.arm64.tgz" -O cri-dockerd-0.3.9.arm64.tgz
# wget -c "http://199.115.230.237:12345/kubernetes/cri-dockerd-0.3.9.arm64.tgz" -O cri-dockerd-0.3.9.arm64.tgz
wget -c "http://199.115.230.237:12345/kubernetes/cri-dockerd-0.3.9.arm64.tgz" -O cri-dockerd-0.3.9.arm64.tgz

date
