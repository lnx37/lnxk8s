#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source env.sh
echo "${KUBE_APISERVER_IP}"

mkdir -p artifact/kubernetes/kube-scheduler

cd artifact/kubernetes/kube-scheduler

# -- template
# cfssl print-defaults config
# cfssl print-defaults csr
#
# -- kubeadm
# cat /etc/kubernetes/scheduler.conf |grep "client-certificate-data" |awk '{print $2}' |base64 -d |cfssl-certinfo --cert -
#
# -- refer
# https://kubernetes.io/docs/setup/best-practices/certificates/
# https://kubernetes.io/docs/tasks/administer-cluster/certificates/
# https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/04-certificate-authority.md
cat <<EOF >kube-scheduler-csr.json
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CHANGEME",
      "ST": "CHANGEME",
      "L": "CHANGEME",
      "O": "system:kube-scheduler",
      "OU": "CHANGEME"
    }
  ]
}
EOF

# -- input
# ../ca.pem
# ../ca-key.pem
# ../ca-config.json
# kube-scheduler-csr.json
#
# -- output
# kube-scheduler-key.pem
# kube-scheduler.csr
# kube-scheduler.pem
cfssl gencert \
  -ca=../ca.pem \
  -ca-key=../ca-key.pem \
  -config=../ca-config.json \
  -profile=kubernetes \
  kube-scheduler-csr.json |cfssljson -bare kube-scheduler

# -- kubeadm
# cat /etc/kubernetes/scheduler.conf
#
# -- refer
# https://kubernetes.io/docs/setup/best-practices/certificates/
# https://kubernetes.io/docs/reference/kubectl/generated/kubectl_config/
# https://kubernetes.io/docs/reference/access-authn-authz/kubelet-tls-bootstrapping/
# https://github.com/kubernetes/kubernetes/blob/master/cluster/common.sh
# https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/05-kubernetes-configuration-files.md
#
# /opt/kubernetes/kube-scheduler/kube-scheduler.kubeconfig
KUBECONFIG="./kube-scheduler.kubeconfig"
KUBE_APISERVER="https://${KUBE_APISERVER_IP}:6443"
[ -f "$KUBECONFIG" ] && rm -f "$KUBECONFIG"
kubectl config set-cluster kubernetes \
  --certificate-authority=../ca.pem \
  --embed-certs=true \
  --kubeconfig="$KUBECONFIG" \
  --server="${KUBE_APISERVER}"
kubectl config set-credentials system:kube-scheduler \
  --client-certificate=./kube-scheduler.pem \
  --client-key=./kube-scheduler-key.pem \
  --embed-certs=true \
  --kubeconfig="$KUBECONFIG"
kubectl config set-context system:kube-scheduler@kubernetes \
  --cluster=kubernetes \
  --kubeconfig="$KUBECONFIG" \
  --user=system:kube-scheduler
kubectl config use-context system:kube-scheduler@kubernetes --kubeconfig="$KUBECONFIG"

# -- kubeadm
# cat /etc/kubernetes/manifests/kube-scheduler.yaml
#
# -- refer
# https://kubernetes.io/docs/reference/command-line-tools-reference/kube-scheduler/
#
# -- changelog
# modify, --authentication-kubeconfig=/etc/kubernetes/scheduler.conf
# modify, --authorization-kubeconfig=/etc/kubernetes/scheduler.conf
#
# /opt/kubernetes/kube-scheduler/kube-scheduler.conf
cat <<EOF >kube-scheduler.conf
KUBE_SCHEDULER_OPTS=" \\
  --authentication-kubeconfig=/opt/kubernetes/kube-scheduler/kube-scheduler.kubeconfig \\
  --authorization-kubeconfig=/opt/kubernetes/kube-scheduler/kube-scheduler.kubeconfig \\
  --bind-address=127.0.0.1 \\
  --kubeconfig=/opt/kubernetes/kube-scheduler/kube-scheduler.kubeconfig \\
  --leader-elect=true \\
"
EOF

# /usr/lib/systemd/system/kube-scheduler.service
cat <<\EOF >kube-scheduler.service
[Unit]
Description=Kubernetes kube-scheduler
Documentation=https://kubernetes.io/docs/
Wants=network-online.target
After=network-online.target

[Service]
EnvironmentFile=/opt/kubernetes/kube-scheduler/kube-scheduler.conf
ExecStart=/opt/kubernetes/kube-scheduler/kube-scheduler $KUBE_SCHEDULER_OPTS
Restart=always

[Install]
WantedBy=multi-user.target
EOF

date
