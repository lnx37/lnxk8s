#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

[ -f /usr/local/bin/nerdctl ] && echo "/usr/local/bin/nerdctl already exists" && exit 0

# wget -c "https://github.com/containerd/nerdctl/releases/download/v1.7.0/nerdctl-1.7.0-linux-amd64.tar.gz" -O nerdctl-1.7.0-linux-amd64.tar.gz
wget -c "http://199.115.230.237:12345/kubernetes/nerdctl-1.7.0-linux-amd64.tar.gz" -O nerdctl-1.7.0-linux-amd64.tar.gz

[ -d nerdctl-1.7.0-linux-amd64 ] && rm -rf nerdctl-1.7.0-linux-amd64
mkdir -p nerdctl-1.7.0-linux-amd64
tar xzf nerdctl-1.7.0-linux-amd64.tar.gz -C nerdctl-1.7.0-linux-amd64

chown -R root:root nerdctl-1.7.0-linux-amd64
chmod +x nerdctl-1.7.0-linux-amd64/nerdctl

cp -a nerdctl-1.7.0-linux-amd64/nerdctl /usr/local/bin/

date
