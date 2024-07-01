#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source env.sh
echo "${KUBE_APISERVER_IP}"

mkdir -p artifact/kubernetes/kubectl

cd artifact/kubernetes/kubectl

# -- template
# cfssl print-defaults config
# cfssl print-defaults csr
#
# -- kubeadm
# cat /etc/kubernetes/admin.conf |grep "client-certificate-data" |awk '{print $2}' |base64 -d |cfssl-certinfo --cert -
#
# -- refer
# https://kubernetes.io/docs/setup/best-practices/certificates/
# https://kubernetes.io/docs/tasks/administer-cluster/certificates/
# https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/04-certificate-authority.md
cat <<EOF >kubectl-csr.json
{
  "CN": "kubernetes-admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CHANGEME",
      "ST": "CHANGEME",
      "L": "CHANGEME",
      "O": "system:masters",
      "OU": "CHANGEME"
    }
  ]
}
EOF

# -- input
# ../ca.pem
# ../ca-key.pem
# ../ca-config.json
# kubectl-csr.json
#
# -- output
# kubectl-key.pem
# kubectl.csr
# kubectl.pem
cfssl gencert \
  -ca=../ca.pem \
  -ca-key=../ca-key.pem \
  -config=../ca-config.json \
  -profile=kubernetes \
  kubectl-csr.json |cfssljson -bare kubectl

# -- kubeadm
# cat /etc/kubernetes/admin.conf
#
# -- refer
# https://kubernetes.io/docs/setup/best-practices/certificates/
# https://kubernetes.io/docs/reference/kubectl/generated/kubectl_config/
# https://kubernetes.io/docs/reference/access-authn-authz/kubelet-tls-bootstrapping/
# https://github.com/kubernetes/kubernetes/blob/master/cluster/common.sh
# https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/05-kubernetes-configuration-files.md
#
# KUBECONFIG="/root/.kube/config"
KUBECONFIG="./kubectl.kubeconfig"
KUBE_APISERVER="https://${KUBE_APISERVER_IP}:6443"
[ -f "$KUBECONFIG" ] && rm -f "$KUBECONFIG"
kubectl config set-cluster kubernetes \
  --certificate-authority=../ca.pem \
  --embed-certs=true \
  --kubeconfig="${KUBECONFIG}" \
  --server="${KUBE_APISERVER}"
kubectl config set-credentials kubernetes-admin \
  --client-certificate=./kubectl.pem \
  --client-key=./kubectl-key.pem \
  --embed-certs=true \
  --kubeconfig="${KUBECONFIG}"
kubectl config set-context kubernetes-admin@kubernetes \
  --cluster=kubernetes \
  --kubeconfig="${KUBECONFIG}" \
  --user=kubernetes-admin
kubectl config use-context kubernetes-admin@kubernetes --kubeconfig="${KUBECONFIG}"

date
