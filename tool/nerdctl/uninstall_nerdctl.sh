#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

rm -f /usr/local/bin/nerdctl
rm -rf /var/lib/nerdctl
rm -f /etc/cni/net.d/nerdctl-bridge.conflist

ifconfig nerdctl0 down || true
ip link delete nerdctl0 || true

date
