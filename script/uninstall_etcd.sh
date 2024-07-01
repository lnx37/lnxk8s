#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

systemctl stop etcd || true
rm -f /lib/systemd/system/etcd.service
systemctl daemon-reload

rm -rf /opt/etcd
rm -rf /var/lib/etcd

date
