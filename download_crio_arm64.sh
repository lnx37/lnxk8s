#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg

cd pkg

# https://github.com/cri-o/cri-o
# https://github.com/cri-o/cri-o/releases
#
# wget -c "https://storage.googleapis.com/cri-o/artifacts/cri-o.arm64.v1.30.1.tar.gz" -O cri-o.arm64.v1.30.1.tar.gz
# wget -c "http://199.115.230.237:12345/kubernetes/cri-o.arm64.v1.30.1.tar.gz" -O cri-o.arm64.v1.30.1.tar.gz
wget -c "http://199.115.230.237:12345/kubernetes/cri-o.arm64.v1.30.1.tar.gz" -O cri-o.arm64.v1.30.1.tar.gz

date
