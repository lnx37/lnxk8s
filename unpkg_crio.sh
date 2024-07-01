#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg
mkdir -p artifact/crio

cd pkg

# wget -c "https://storage.googleapis.com/cri-o/artifacts/cri-o.amd64.v1.30.1.tar.gz" -O cri-o.amd64.v1.30.1.tar.gz
# wget -c "http://199.115.230.237:12345/kubernetes/cri-o.amd64.v1.30.1.tar.gz" -O cri-o.amd64.v1.30.1.tar.gz

[ -d cri-o ] && rm -rf cri-o
mkdir -p cri-o
tar xzf cri-o.amd64.v1.30.1.tar.gz

chown -R root:root cri-o

chmod +x cri-o/bin/crictl
chmod +x cri-o/bin/crio
chmod +x cri-o/bin/crio-conmon
chmod +x cri-o/bin/crio-conmonrs
chmod +x cri-o/bin/crio-crun
chmod +x cri-o/bin/crio-runc
chmod +x cri-o/bin/pinns

cp -a cri-o/bin/crictl        ../artifact/crio/crictl
cp -a cri-o/bin/crio          ../artifact/crio/crio
cp -a cri-o/bin/crio-conmon   ../artifact/crio/crio-conmon
cp -a cri-o/bin/crio-conmonrs ../artifact/crio/crio-conmonrs
cp -a cri-o/bin/crio-crun     ../artifact/crio/crio-crun
cp -a cri-o/bin/crio-runc     ../artifact/crio/crio-runc
cp -a cri-o/bin/pinns         ../artifact/crio/pinns

date
