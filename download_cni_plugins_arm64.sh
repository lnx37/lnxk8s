#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg

cd pkg

# https://github.com/containernetworking/plugins
# https://github.com/containernetworking/plugins/releases
#
# wget -c "https://github.com/containernetworking/plugins/releases/download/v1.4.0/cni-plugins-linux-arm64-v1.4.0.tgz" -O cni-plugins-linux-arm64-v1.4.0.tgz
# wget -c "http://199.115.230.237:12345/kubernetes/cni-plugins-linux-arm64-v1.4.0.tgz" -O cni-plugins-linux-arm64-v1.4.0.tgz
wget -c "http://199.115.230.237:12345/kubernetes/cni-plugins-linux-arm64-v1.4.0.tgz" -O cni-plugins-linux-arm64-v1.4.0.tgz

date
