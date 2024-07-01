#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

MASTER_IP="39.108.113.24"
WORKER_IP="120.25.247.16"

ssh root@"${MASTER_IP}" "hostname"
ssh root@"${WORKER_IP}" "hostname"

ssh root@"${MASTER_IP}" "which tree >/dev/null 2>&1 || yum install tree -y >/dev/null 2>&1"
ssh root@"${WORKER_IP}" "which tree >/dev/null 2>&1 || yum install tree -y >/dev/null 2>&1"

rm -rf master
rm -rf worker

mkdir -p master/etc_kubernetes
mkdir -p master/var_lib_kubelet
mkdir -p worker/etc_kubernetes
mkdir -p worker/var_lib_kubelet

rsync -avz root@"${MASTER_IP}":/etc/kubernetes/             master/etc_kubernetes/
rsync -avz root@"${MASTER_IP}":/var/lib/kubelet/config.yaml master/var_lib_kubelet/
rsync -avz root@"${MASTER_IP}":/var/lib/kubelet/pki         master/var_lib_kubelet/

rsync -avz root@"${WORKER_IP}":/etc/kubernetes/             worker/etc_kubernetes/
rsync -avz root@"${WORKER_IP}":/var/lib/kubelet/config.yaml worker/var_lib_kubelet/
rsync -avz root@"${WORKER_IP}":/var/lib/kubelet/pki         worker/var_lib_kubelet/

rsync -avz ../common/collect_master.sh root@"${MASTER_IP}":/tmp/
rsync -avz ../common/collect_worker.sh root@"${WORKER_IP}":/tmp/

ssh root@"${MASTER_IP}" "bash /tmp/collect_master.sh"
ssh root@"${WORKER_IP}" "bash /tmp/collect_worker.sh"

rsync -avz root@"${MASTER_IP}":/tmp/master/kubeadm_config.yml                master/kubeadm_config.yml
rsync -avz root@"${MASTER_IP}":/tmp/master/tree_etc_kubernetes.txt           master/tree_etc_kubernetes.txt
rsync -avz root@"${MASTER_IP}":/tmp/master/kubectl-kubeconfig.conf           master/kubectl-kubeconfig.conf
rsync -avz root@"${MASTER_IP}":/tmp/master/ps_ef_etcd.txt                    master/ps_ef_etcd.txt
rsync -avz root@"${MASTER_IP}":/tmp/master/ps_ef_kube_apiserver.txt          master/ps_ef_kube_apiserver.txt
rsync -avz root@"${MASTER_IP}":/tmp/master/ps_ef_kube_controller_manager.txt master/ps_ef_kube_controller_manager.txt
rsync -avz root@"${MASTER_IP}":/tmp/master/ps_ef_kube_proxy.txt              master/ps_ef_kube_proxy.txt
rsync -avz root@"${MASTER_IP}":/tmp/master/ps_ef_kube_scheduler.txt          master/ps_ef_kube_scheduler.txt
rsync -avz root@"${MASTER_IP}":/tmp/master/ps_ef_kubelet.txt                 master/ps_ef_kubelet.txt
rsync -avz root@"${MASTER_IP}":/tmp/master/kube-proxy-config.conf            master/kube-proxy-config.conf
rsync -avz root@"${MASTER_IP}":/tmp/master/kube-proxy-kubeconfig.conf        master/kube-proxy-kubeconfig.conf

rsync -avz root@"${WORKER_IP}":/tmp/worker/tree_etc_kubernetes.txt           worker/tree_etc_kubernetes.txt
rsync -avz root@"${WORKER_IP}":/tmp/worker/ps_ef_kube_proxy.txt              worker/ps_ef_kube_proxy.txt
rsync -avz root@"${WORKER_IP}":/tmp/worker/ps_ef_kubelet.txt                 worker/ps_ef_kubelet.txt

date
