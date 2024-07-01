#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

# kubectl
rm -f /usr/local/bin/kubectl
rm -rf /opt/kubernetes/kubectl
rm -f /root/.kube/config
rm -rf /root/.kube
sed -i "/kubectl completion bash/d" ~/.bashrc

# kube_apiserver
ps -ef |grep "kube-apiserver" |grep -v "grep" |awk '{print $2}' |xargs kill -9 >/dev/null 2>&1 || true
systemctl stop kube-apiserver || true
rm -f /usr/lib/systemd/system/kube-apiserver.service
systemctl daemon-reload
rm -rf /opt/kubernetes/kube-apiserver

# kube_scheduler
systemctl stop kube-scheduler || true
rm -f /usr/lib/systemd/system/kube-scheduler.service
systemctl daemon-reload
rm -rf /opt/kubernetes/kube-scheduler

# kube_controller_manager
systemctl stop kube-controller-manager || true
rm -f /usr/lib/systemd/system/kube-controller-manager.service
systemctl daemon-reload
rm -rf /opt/kubernetes/kube-controller-manager

# misc
rm -rf /opt/etcd
rm -rf /opt/kubernetes

date
