#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p /tmp/master

kubectl -n kube-system get cm kubeadm-config -o yaml >/tmp/master/kubeadm_config.yml

tree /etc/kubernetes/ --charset=ascii >/tmp/master/tree_etc_kubernetes.txt

cat /root/.kube/config >/tmp/master/kubectl-kubeconfig.conf

ps -ef |grep "etcd " |grep -v "grep" |awk '{ for(i=8; i<=NF; ++i) print $i }'                    >/tmp/master/ps_ef_etcd.txt
ps -ef |grep "kube-apiserver " |grep -v "grep" |awk '{ for(i=8; i<=NF; ++i) print $i }'          >/tmp/master/ps_ef_kube_apiserver.txt
ps -ef |grep "kube-controller-manager " |grep -v "grep" |awk '{ for(i=8; i<=NF; ++i) print $i }' >/tmp/master/ps_ef_kube_controller_manager.txt
ps -ef |grep "kube-proxy " |grep -v "grep" |awk '{ for(i=8; i<=NF; ++i) print $i }'              >/tmp/master/ps_ef_kube_proxy.txt
ps -ef |grep "kube-scheduler " |grep -v "grep" |awk '{ for(i=8; i<=NF; ++i) print $i }'          >/tmp/master/ps_ef_kube_scheduler.txt
ps -ef |grep "kubelet " |grep -v "grep" |awk '{ for(i=8; i<=NF; ++i) print $i }'                 >/tmp/master/ps_ef_kubelet.txt

hostname=$(hostname |tr '[:upper:]' '[:lower:]')
kube_proxy_name=$(kubectl get pod -n kube-system -o wide |grep "$hostname" |grep "kube-proxy" |awk '{print $1}')
kubectl exec -it "${kube_proxy_name}" -n kube-system -- cat /var/lib/kube-proxy/config.conf     >/tmp/master/kube-proxy-config.conf
kubectl exec -it "${kube_proxy_name}" -n kube-system -- cat /var/lib/kube-proxy/kubeconfig.conf >/tmp/master/kube-proxy-kubeconfig.conf

date
