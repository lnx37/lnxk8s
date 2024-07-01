#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg

cd pkg

# https://github.com/etcd-io/etcd
# https://github.com/etcd-io/etcd/releases
#
# wget -c "https://github.com/etcd-io/etcd/releases/download/v3.4.9/etcd-v3.4.9-linux-amd64.tar.gz" -O etcd-v3.4.9-linux-amd64.tar.gz
# wget -c "https://github.com/etcd-io/etcd/releases/download/v3.4.30/etcd-v3.4.30-linux-amd64.tar.gz" -O etcd-v3.4.30-linux-amd64.tar.gz
# wget -c "https://github.com/etcd-io/etcd/releases/download/v3.5.12/etcd-v3.5.12-linux-amd64.tar.gz" -O etcd-v3.5.12-linux-amd64.tar.gz
# wget -c "http://199.115.230.237:12345/kubernetes/etcd-v3.4.9-linux-amd64.tar.gz" -O etcd-v3.4.9-linux-amd64.tar.gz
# wget -c "http://199.115.230.237:12345/kubernetes/etcd-v3.4.30-linux-amd64.tar.gz" -O etcd-v3.4.30-linux-amd64.tar.gz
# wget -c "http://199.115.230.237:12345/kubernetes/etcd-v3.5.12-linux-amd64.tar.gz" -O etcd-v3.5.12-linux-amd64.tar.gz
wget -c "http://199.115.230.237:12345/kubernetes/etcd-v3.5.12-linux-amd64.tar.gz" -O etcd-v3.5.12-linux-amd64.tar.gz

date
