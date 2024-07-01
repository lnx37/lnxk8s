#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

[ -f /usr/local/bin/helm ] && echo "/usr/local/bin/helm already exists" && exit 0

# wget -c "https://get.helm.sh/helm-v3.14.1-linux-amd64.tar.gz" -O helm-v3.14.1-linux-amd64.tar.gz
# wget -c "https://mirrors.huaweicloud.com/helm/v3.14.1/helm-v3.14.1-linux-amd64.tar.gz" -O helm-v3.14.1-linux-amd64.tar.gz
wget -c "http://199.115.230.237:12345/kubernetes/helm-v3.14.1-linux-amd64.tar.gz" -O helm-v3.14.1-linux-amd64.tar.gz

[ -d linux-amd64 ] && rm -rf linux-amd64
tar xzf helm-v3.14.1-linux-amd64.tar.gz

chown -R root:root linux-amd64
chmod +x linux-amd64/helm

cp -a linux-amd64/helm /usr/local/bin/

helm version

date
