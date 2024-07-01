#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg

cd pkg

# https://github.com/opencontainers/runc
# https://github.com/opencontainers/runc/releases
#
# wget -c "https://github.com/opencontainers/runc/releases/download/v1.1.11/runc.amd64" -O runc.amd64
#
# mkdir -p runc_v1.1.11
# wget -c "http://199.115.230.237:12345/kubernetes/runc_v1.1.11/runc.amd64" -O runc_v1.1.11/runc.amd64
mkdir -p runc_v1.1.11
wget -c "http://199.115.230.237:12345/kubernetes/runc_v1.1.11/runc.amd64" -O runc_v1.1.11/runc.amd64

date
