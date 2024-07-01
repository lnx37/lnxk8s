#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source env.sh
echo "${KUBE_APISERVER_IP}"
echo "${ETCD_IP_LIST[@]}"

mkdir -p artifact/kubernetes/kube-apiserver

cd artifact/kubernetes/kube-apiserver

# -- template
# cfssl print-defaults config
# cfssl print-defaults csr
#
# -- kubeadm
# cfssl-certinfo --cert /etc/kubernetes/pki/apiserver.crt
#
# -- refer
# https://kubernetes.io/docs/setup/best-practices/certificates/
# https://kubernetes.io/docs/tasks/administer-cluster/certificates/
# https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/04-certificate-authority.md
cat <<EOF >kube-apiserver-csr.json
{
  "CN": "kube-apiserver",
  "hosts": [
    "10.0.0.1",
    "10.96.0.1",
    "127.0.0.1",
    "${KUBE_APISERVER_IP}",
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "kubernetes.default.svc.cluster",
    "kubernetes.default.svc.cluster.local"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CHANGEME",
      "ST": "CHANGEME",
      "L": "CHANGEME",
      "O": "kubernetes",
      "OU": "CHANGEME"
    }
  ]
}
EOF

# -- input
# ../ca.pem
# ../ca-key.pem
# ../ca-config.json
# kube-apiserver-csr.json
#
# -- output
# kube-apiserver-key.pem
# kube-apiserver.csr
# kube-apiserver.pem
cfssl gencert \
  -ca=../ca.pem \
  -ca-key=../ca-key.pem \
  -config=../ca-config.json \
  -profile=kubernetes \
  kube-apiserver-csr.json |cfssljson -bare kube-apiserver

ETCD_SERVERS=""
for ETCD_IP in "${ETCD_IP_LIST[@]}"; do
  ETCD_SERVERS="${ETCD_SERVERS},https://${ETCD_IP}:2379"
done
ETCD_SERVERS="$(echo "${ETCD_SERVERS}" |sed "s/^,//g")"

# -- kubeadm
# cat /etc/kubernetes/manifests/kube-apiserver.yaml
#
# -- changelog
# modify, --advertise-address=172.22.25.119
# modify, --client-ca-file=/etc/kubernetes/pki/ca.crt
# modify, --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt
# modify, --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt
# modify, --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key
# modify, --etcd-servers=https://127.0.0.1:2379
# modify, --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt
# modify, --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key
# modify, --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt
# modify, --proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key
# modify, --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt
# modify, --service-account-key-file=/etc/kubernetes/pki/sa.pub
# modify, --service-account-signing-key-file=/etc/kubernetes/pki/sa.key
# modify, --tls-cert-file=/etc/kubernetes/pki/apiserver.crt
# modify, --tls-private-key-file=/etc/kubernetes/pki/apiserver.key
#
# -- refer
# https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/
# https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/
# https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#which-plugins-are-enabled-by-default
# https://kubernetes.io/docs/tasks/extend-kubernetes/configure-aggregation-layer/
#
# /opt/kubernetes/kube-apiserver/kube-apiserver.conf
cat <<EOF >kube-apiserver.conf
KUBE_APISERVER_OPTS=" \\
  --advertise-address=${KUBE_APISERVER_IP} \\
  --allow-privileged=true \\
  --authorization-mode=Node,RBAC \\
  --client-ca-file=/opt/kubernetes/ca.pem \\
  --enable-admission-plugins=NodeRestriction \\
  --enable-bootstrap-token-auth=true \\
  --etcd-cafile=/opt/etcd/ca.pem \\
  --etcd-certfile=/opt/etcd/server.pem \\
  --etcd-keyfile=/opt/etcd/server-key.pem \\
  --etcd-servers=${ETCD_SERVERS} \\
  --kubelet-client-certificate=/opt/kubernetes/kube-apiserver/kube-apiserver.pem \\
  --kubelet-client-key=/opt/kubernetes/kube-apiserver/kube-apiserver-key.pem \\
  --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname \\
  --proxy-client-cert-file=/opt/kubernetes/front-proxy-client.pem \\
  --proxy-client-key-file=/opt/kubernetes/front-proxy-client-key.pem \\
  --requestheader-allowed-names=front-proxy-client \\
  --requestheader-client-ca-file=/opt/kubernetes/front-proxy-ca.pem \\
  --requestheader-extra-headers-prefix=X-Remote-Extra- \\
  --requestheader-group-headers=X-Remote-Group \\
  --requestheader-username-headers=X-Remote-User \\
  --secure-port=6443 \\
  --service-account-issuer=https://kubernetes.default.svc.cluster.local \\
  --service-account-key-file=/opt/kubernetes/sa.pub \\
  --service-account-signing-key-file=/opt/kubernetes/sa.key \\
  --service-cluster-ip-range=10.96.0.0/12 \\
  --tls-cert-file=/opt/kubernetes/kube-apiserver/kube-apiserver.pem \\
  --tls-private-key-file=/opt/kubernetes/kube-apiserver/kube-apiserver-key.pem \\
"
EOF

# /usr/lib/systemd/system/kube-apiserver.service
cat <<\EOF >kube-apiserver.service
[Unit]
Description=Kubernetes kube-apiserver
Documentation=https://kubernetes.io/docs/
Wants=network-online.target
After=network-online.target

[Service]
EnvironmentFile=/opt/kubernetes/kube-apiserver/kube-apiserver.conf
ExecStart=/opt/kubernetes/kube-apiserver/kube-apiserver $KUBE_APISERVER_OPTS
Restart=always

[Install]
WantedBy=multi-user.target
EOF

date
