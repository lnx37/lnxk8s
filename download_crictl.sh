#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg

cd pkg

# https://github.com/kubernetes-sigs/cri-tools
# https://github.com/kubernetes-sigs/cri-tools/releases
#
# wget -c "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.28.0/crictl-v1.28.0-linux-amd64.tar.gz" -O crictl-v1.28.0-linux-amd64.tar.gz
# wget -c "http://199.115.230.237:12345/kubernetes/crictl-v1.28.0-linux-amd64.tar.gz" -O crictl-v1.28.0-linux-amd64.tar.gz
wget -c "http://199.115.230.237:12345/kubernetes/crictl-v1.28.0-linux-amd64.tar.gz" -O crictl-v1.28.0-linux-amd64.tar.gz

date
