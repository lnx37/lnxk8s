#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

[ "$#" -ne 1 ] && echo "invalid argument, need an ip" && exit 1

ETCD_IP="$1"
echo "${ETCD_IP}"

mkdir -p artifact

cd artifact

ETCD_NAME="$(echo "${ETCD_IP}" |sed "s/\./_/g")"
echo "${ETCD_NAME}"

cat <<\EOF >"install_etcd_${ETCD_NAME}.sh"
#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p /opt/etcd

SCRIPT_NAME="$(basename "$0")"
ETCD_NAME="$(echo "${SCRIPT_NAME}" |sed -e "s/^install_etcd_//g" -e "s/\.sh$//g")"
echo "${SCRIPT_NAME}"
echo "${ETCD_NAME}"

cp -a etcd/ca-key.pem               /opt/etcd/ca-key.pem
cp -a etcd/ca.pem                   /opt/etcd/ca.pem
cp -a etcd/etcd                     /opt/etcd/etcd
cp -a etcd/etcd_"${ETCD_NAME}.conf" /opt/etcd/etcd.conf
cp -a etcd/etcd.service             /usr/lib/systemd/system/etcd.service
cp -a etcd/etcdctl                  /opt/etcd/etcdctl
cp -a etcd/server-key.pem           /opt/etcd/server-key.pem
cp -a etcd/server.pem               /opt/etcd/server.pem

systemctl daemon-reload
systemctl enable etcd
timeout 3 systemctl restart etcd || true

date
EOF

date
