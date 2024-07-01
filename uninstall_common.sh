#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

rm -rf artifact

rm -f /usr/local/cfssl
rm -f /usr/local/cfssl-certinfo
rm -f /usr/local/cfssljson

rm -f /usr/local/kubectl
rm -rf /root/.kube
sed -i "/kubectl completion bash/d" ~/.bashrc

date
