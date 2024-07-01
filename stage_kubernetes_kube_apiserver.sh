#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p artifact

cd artifact

cat <<\EOF >install_kubernetes_kube_apiserver.sh
#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p /opt/etcd
mkdir -p /opt/kubernetes/kube-apiserver

cp -a etcd/ca-key.pem     /opt/etcd/ca-key.pem
cp -a etcd/ca.pem         /opt/etcd/ca.pem
cp -a etcd/server-key.pem /opt/etcd/server-key.pem
cp -a etcd/server.pem     /opt/etcd/server.pem

cp -a kubernetes/ca-key.pem                 /opt/kubernetes/ca-key.pem
cp -a kubernetes/ca.pem                     /opt/kubernetes/ca.pem
cp -a kubernetes/front-proxy-ca-key.pem     /opt/kubernetes/front-proxy-ca-key.pem
cp -a kubernetes/front-proxy-ca.pem         /opt/kubernetes/front-proxy-ca.pem
cp -a kubernetes/front-proxy-client-key.pem /opt/kubernetes/front-proxy-client-key.pem
cp -a kubernetes/front-proxy-client.pem     /opt/kubernetes/front-proxy-client.pem
cp -a kubernetes/sa.key                     /opt/kubernetes/sa.key
cp -a kubernetes/sa.pub                     /opt/kubernetes/sa.pub

cp -a kubernetes/kube-apiserver/kube-apiserver         /opt/kubernetes/kube-apiserver/kube-apiserver
cp -a kubernetes/kube-apiserver/kube-apiserver-key.pem /opt/kubernetes/kube-apiserver/kube-apiserver-key.pem
cp -a kubernetes/kube-apiserver/kube-apiserver.conf    /opt/kubernetes/kube-apiserver/kube-apiserver.conf
cp -a kubernetes/kube-apiserver/kube-apiserver.pem     /opt/kubernetes/kube-apiserver/kube-apiserver.pem
cp -a kubernetes/kube-apiserver/kube-apiserver.service /usr/lib/systemd/system/kube-apiserver.service

systemctl daemon-reload
systemctl enable kube-apiserver
systemctl restart kube-apiserver || true

date
EOF

date
