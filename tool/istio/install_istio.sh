#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

# wget -c "https://github.com/istio/istio/releases/download/1.21.0/istio-1.21.0-linux-amd64.tar.gz" -O istio-1.21.0-linux-amd64.tar.gz
wget -c "http://199.115.230.237:12345/kubernetes/istio-1.21.0-linux-amd64.tar.gz" -O istio-1.21.0-linux-amd64.tar.gz

[ -d istio-1.21.0 ] && rm -rf istio-1.21.0
tar xzf istio-1.21.0-linux-amd64.tar.gz

cp -a istio-1.21.0/bin/istioctl /usr/local/bin/

date
