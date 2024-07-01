#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p /tmp/worker

tree /etc/kubernetes/ --charset=ascii >/tmp/worker/tree_etc_kubernetes.txt

ps -ef |grep "kube-proxy " |grep -v "grep" |awk '{ for(i=8; i<=NF; ++i) print $i }' >/tmp/worker/ps_ef_kube_proxy.txt
ps -ef |grep "kubelet " |grep -v "grep" |awk '{ for(i=8; i<=NF; ++i) print $i }'    >/tmp/worker/ps_ef_kubelet.txt

date
