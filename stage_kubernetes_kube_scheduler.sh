#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p artifact

cd artifact

cat <<\EOF >install_kubernetes_kube_scheduler.sh
#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p /opt/kubernetes/kube-scheduler

cp -a kubernetes/kube-scheduler/kube-scheduler            /opt/kubernetes/kube-scheduler/kube-scheduler
cp -a kubernetes/kube-scheduler/kube-scheduler.conf       /opt/kubernetes/kube-scheduler/kube-scheduler.conf
cp -a kubernetes/kube-scheduler/kube-scheduler.kubeconfig /opt/kubernetes/kube-scheduler/kube-scheduler.kubeconfig
cp -a kubernetes/kube-scheduler/kube-scheduler.service    /usr/lib/systemd/system/kube-scheduler.service

systemctl daemon-reload
systemctl enable kube-scheduler
systemctl restart kube-scheduler || true

date
EOF

date
