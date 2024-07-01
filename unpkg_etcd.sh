#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg
mkdir -p artifact/etcd

cd pkg

# wget -c "https://github.com/etcd-io/etcd/releases/download/v3.5.12/etcd-v3.5.12-linux-amd64.tar.gz" -O etcd-v3.5.12-linux-amd64.tar.gz
# wget -c "http://199.115.230.237:12345/kubernetes/etcd-v3.5.12-linux-amd64.tar.gz" -O etcd-v3.5.12-linux-amd64.tar.gz

[ -d etcd-v3.5.12-linux-amd64 ] && rm -rf etcd-v3.5.12-linux-amd64
tar xzf etcd-v3.5.12-linux-amd64.tar.gz

chown -R root:root etcd-v3.5.12-linux-amd64

chmod +x etcd-v3.5.12-linux-amd64/etcd
chmod +x etcd-v3.5.12-linux-amd64/etcdctl

cp -a etcd-v3.5.12-linux-amd64/etcd    ../artifact/etcd/etcd
cp -a etcd-v3.5.12-linux-amd64/etcdctl ../artifact/etcd/etcdctl

date
