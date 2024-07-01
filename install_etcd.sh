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

ETCD_NAME="$(echo "${ETCD_IP}" |sed "s/\./_/g")"
echo "${ETCD_NAME}"

ssh root@"${ETCD_IP}" "bash /opt/artifact/install_etcd_${ETCD_NAME}.sh"

date
