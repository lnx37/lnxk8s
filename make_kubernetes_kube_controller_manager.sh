#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source env.sh
echo "${KUBE_APISERVER_IP}"

mkdir -p artifact/kubernetes/kube-controller-manager

cd artifact/kubernetes/kube-controller-manager

# -- template
# cfssl print-defaults config
# cfssl print-defaults csr
#
# -- kubeadm
# cat /etc/kubernetes/controller-manager.conf |grep "client-certificate-data" |awk '{print $2}' |base64 -d |cfssl-certinfo --cert
#
# -- refer
# https://kubernetes.io/docs/setup/best-practices/certificates/
# https://kubernetes.io/docs/tasks/administer-cluster/certificates/
# https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/04-certificate-authority.md
cat <<EOF >kube-controller-manager-csr.json
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CHANGEME",
      "ST": "CHANGEME",
      "L": "CHANGEME",
      "O": "system:kube-controller-manager",
      "OU": "CHANGEME"
    }
  ]
}
EOF

# -- input
# ../ca.pem
# ../ca-key.pem
# ../ca-config.json
# kube-controller-manager-csr.json
#
# -- output
# kube-controller-manager-key.pem
# kube-controller-manager.csr
# kube-controller-manager.pem
cfssl gencert \
  -ca=../ca.pem \
  -ca-key=../ca-key.pem \
  -config=../ca-config.json \
  -profile=kubernetes \
  kube-controller-manager-csr.json |cfssljson -bare kube-controller-manager

# -- kubeadm
# cat /etc/kubernetes/controller-manager.conf
#
# -- refer
# https://kubernetes.io/docs/setup/best-practices/certificates/
# https://kubernetes.io/docs/reference/kubectl/generated/kubectl_config/
# https://kubernetes.io/docs/reference/access-authn-authz/kubelet-tls-bootstrapping/
# https://github.com/kubernetes/kubernetes/blob/master/cluster/common.sh
# https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/05-kubernetes-configuration-files.md
#
# /opt/kubernetes/kube-controller-manager/kube-controller-manager.kubeconfig
KUBECONFIG="./kube-controller-manager.kubeconfig"
KUBE_APISERVER="https://${KUBE_APISERVER_IP}:6443"
[ -f "$KUBECONFIG" ] && rm -f "$KUBECONFIG"
kubectl config set-cluster kubernetes \
  --certificate-authority=../ca.pem \
  --embed-certs=true \
  --kubeconfig="$KUBECONFIG" \
  --server="${KUBE_APISERVER}"
kubectl config set-credentials system:kube-controller-manager \
  --client-certificate=./kube-controller-manager.pem \
  --client-key=./kube-controller-manager-key.pem \
  --embed-certs=true \
  --kubeconfig="$KUBECONFIG"
kubectl config set-context system:kube-controller-manager@kubernetes \
  --cluster=kubernetes \
  --kubeconfig="$KUBECONFIG" \
  --user=system:kube-controller-manager
kubectl config use-context system:kube-controller-manager@kubernetes --kubeconfig="$KUBECONFIG"

# -- kubeadm
# cat /etc/kubernetes/manifests/kube-controller-manager.yaml
#
# -- changelog
# modify, --authentication-kubeconfig=/etc/kubernetes/controller-manager.conf
# modify, --authorization-kubeconfig=/etc/kubernetes/controller-manager.conf
# modify, --client-ca-file=/etc/kubernetes/pki/ca.crt
# modify, --cluster-signing-cert-file=/etc/kubernetes/pki/ca.crt
# modify, --cluster-signing-key-file=/etc/kubernetes/pki/ca.key
# modify, --kubeconfig=/etc/kubernetes/controller-manager.conf
# modify, --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt
# modify, --root-ca-file=/etc/kubernetes/pki/ca.crt
# modify, --service-account-private-key-file=/etc/kubernetes/pki/sa.key
#
# -- refer
# https://kubernetes.io/docs/reference/command-line-tools-reference/kube-controller-manager/
#
# /opt/kubernetes/kube-controller-manager/kube-controller-manager.conf
cat <<EOF >kube-controller-manager.conf
KUBE_CONTROLLER_MANAGER_OPTS=" \\
  --allocate-node-cidrs=true \\
  --authentication-kubeconfig=/opt/kubernetes/kube-controller-manager/kube-controller-manager.kubeconfig \\
  --authorization-kubeconfig=/opt/kubernetes/kube-controller-manager/kube-controller-manager.kubeconfig \\
  --bind-address=127.0.0.1 \\
  --client-ca-file=/opt/kubernetes/ca.pem \\
  --cluster-cidr=10.244.0.0/16 \\
  --cluster-name=kubernetes \\
  --cluster-signing-cert-file=/opt/kubernetes/ca.pem \\
  --cluster-signing-key-file=/opt/kubernetes/ca-key.pem \\
  --controllers=*,bootstrapsigner,tokencleaner \\
  --kubeconfig=/opt/kubernetes/kube-controller-manager/kube-controller-manager.kubeconfig \\
  --leader-elect=true \\
  --requestheader-client-ca-file=/opt/kubernetes/front-proxy-ca.pem \\
  --root-ca-file=/opt/kubernetes/ca.pem \\
  --service-account-private-key-file=/opt/kubernetes/sa.key \\
  --service-cluster-ip-range=10.96.0.0/12 \\
  --use-service-account-credentials=true \\
"
EOF

# /usr/lib/systemd/system/kube-controller-manager.service
cat <<\EOF >kube-controller-manager.service
[Unit]
Description=Kubernetes kube-controller-manager
Documentation=https://kubernetes.io/docs/
Wants=network-online.target
After=network-online.target

[Service]
EnvironmentFile=/opt/kubernetes/kube-controller-manager/kube-controller-manager.conf
ExecStart=/opt/kubernetes/kube-controller-manager/kube-controller-manager $KUBE_CONTROLLER_MANAGER_OPTS
Restart=always

[Install]
WantedBy=multi-user.target
EOF

date
