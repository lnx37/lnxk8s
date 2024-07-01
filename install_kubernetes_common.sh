#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

[ "$#" -ne 1 ] && echo "invalid argument, need an ip" && exit 1

IP="$1"
echo "$IP"

ssh root@"$IP" "bash /opt/artifact/install_kubernetes_common.sh"

date
