#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p artifact

cd artifact

cat <<\EOF >install_kubernetes_kube_proxy.sh
#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p /opt/kubernetes/kube-proxy

cp -a kubernetes/kube-proxy/kube-proxy            /opt/kubernetes/kube-proxy/kube-proxy
cp -a kubernetes/kube-proxy/kube-proxy-config.yml /opt/kubernetes/kube-proxy/kube-proxy-config.yml
cp -a kubernetes/kube-proxy/kube-proxy.conf       /opt/kubernetes/kube-proxy/kube-proxy.conf
cp -a kubernetes/kube-proxy/kube-proxy.kubeconfig /opt/kubernetes/kube-proxy/kube-proxy.kubeconfig
cp -a kubernetes/kube-proxy/kube-proxy.service    /usr/lib/systemd/system/kube-proxy.service

systemctl daemon-reload
systemctl enable kube-proxy
systemctl restart kube-proxy

date
EOF

date
