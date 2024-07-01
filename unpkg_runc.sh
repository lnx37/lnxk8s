#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg
mkdir -p artifact/runc

cd pkg

# wget -c "https://github.com/opencontainers/runc/releases/download/v1.1.11/runc.amd64" -O runc.amd64
# wget -c "http://199.115.230.237:12345/kubernetes/runc_v1.1.11/runc.amd64" -O runc_v1.1.11/runc.amd64

chown -R root:root runc_v1.1.11

chmod +x runc_v1.1.11/runc.amd64

cp -a runc_v1.1.11/runc.amd64 ../artifact/runc/runc

date
