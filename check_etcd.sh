#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source env.sh
echo "${ETCD_IP_LIST[@]}"

ENDPOINTS=""
for ETCD_IP in "${ETCD_IP_LIST[@]}"; do
  ENDPOINTS="${ENDPOINTS},https://${ETCD_IP}:2379"
done
ENDPOINTS="$(echo "${ENDPOINTS}" |sed "s/^,//g")"
echo "$ENDPOINTS"

ETCDCTL_API=3 \
artifact/etcd/etcdctl \
  --cacert=artifact/etcd/ca.pem \
  --cert=artifact/etcd/server.pem \
  --endpoints="$ENDPOINTS" \
  --key=artifact/etcd/server-key.pem \
  --write-out=table \
  endpoint health

ETCDCTL_API=3 \
artifact/etcd/etcdctl \
  --cacert=artifact/etcd/ca.pem \
  --cert=artifact/etcd/server.pem \
  --endpoints="$ENDPOINTS" \
  --key=artifact/etcd/server-key.pem \
  --write-out=table \
  endpoint status

date
