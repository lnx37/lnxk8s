#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg
mkdir -p artifact/cni-plugins

cd pkg

# wget -c "https://github.com/containernetworking/plugins/releases/download/v1.4.0/cni-plugins-linux-arm64-v1.4.0.tgz" -O cni-plugins-linux-arm64-v1.4.0.tgz
# wget -c "http://199.115.230.237:12345/kubernetes/cni-plugins-linux-arm64-v1.4.0.tgz" -O cni-plugins-linux-arm64-v1.4.0.tgz

[ -d cni-plugins-linux-arm64-v1.4.0 ] && rm -rf cni-plugins-linux-arm64-v1.4.0
mkdir -p cni-plugins-linux-arm64-v1.4.0
tar xzf cni-plugins-linux-arm64-v1.4.0.tgz -C cni-plugins-linux-arm64-v1.4.0

chown -R root:root cni-plugins-linux-arm64-v1.4.0

chmod +x cni-plugins-linux-arm64-v1.4.0/bandwidth
chmod +x cni-plugins-linux-arm64-v1.4.0/bridge
chmod +x cni-plugins-linux-arm64-v1.4.0/dhcp
chmod +x cni-plugins-linux-arm64-v1.4.0/dummy
chmod +x cni-plugins-linux-arm64-v1.4.0/firewall
chmod +x cni-plugins-linux-arm64-v1.4.0/host-device
chmod +x cni-plugins-linux-arm64-v1.4.0/host-local
chmod +x cni-plugins-linux-arm64-v1.4.0/ipvlan
chmod +x cni-plugins-linux-arm64-v1.4.0/loopback
chmod +x cni-plugins-linux-arm64-v1.4.0/macvlan
chmod +x cni-plugins-linux-arm64-v1.4.0/portmap
chmod +x cni-plugins-linux-arm64-v1.4.0/ptp
chmod +x cni-plugins-linux-arm64-v1.4.0/sbr
chmod +x cni-plugins-linux-arm64-v1.4.0/static
chmod +x cni-plugins-linux-arm64-v1.4.0/tap
chmod +x cni-plugins-linux-arm64-v1.4.0/tuning
chmod +x cni-plugins-linux-arm64-v1.4.0/vlan
chmod +x cni-plugins-linux-arm64-v1.4.0/vrf

cp -a cni-plugins-linux-arm64-v1.4.0/bandwidth   ../artifact/cni-plugins/bandwidth
cp -a cni-plugins-linux-arm64-v1.4.0/bridge      ../artifact/cni-plugins/bridge
cp -a cni-plugins-linux-arm64-v1.4.0/dhcp        ../artifact/cni-plugins/dhcp
cp -a cni-plugins-linux-arm64-v1.4.0/dummy       ../artifact/cni-plugins/dummy
cp -a cni-plugins-linux-arm64-v1.4.0/firewall    ../artifact/cni-plugins/firewall
cp -a cni-plugins-linux-arm64-v1.4.0/host-device ../artifact/cni-plugins/host-device
cp -a cni-plugins-linux-arm64-v1.4.0/host-local  ../artifact/cni-plugins/host-local
cp -a cni-plugins-linux-arm64-v1.4.0/ipvlan      ../artifact/cni-plugins/ipvlan
cp -a cni-plugins-linux-arm64-v1.4.0/loopback    ../artifact/cni-plugins/loopback
cp -a cni-plugins-linux-arm64-v1.4.0/macvlan     ../artifact/cni-plugins/macvlan
cp -a cni-plugins-linux-arm64-v1.4.0/portmap     ../artifact/cni-plugins/portmap
cp -a cni-plugins-linux-arm64-v1.4.0/ptp         ../artifact/cni-plugins/ptp
cp -a cni-plugins-linux-arm64-v1.4.0/sbr         ../artifact/cni-plugins/sbr
cp -a cni-plugins-linux-arm64-v1.4.0/static      ../artifact/cni-plugins/static
cp -a cni-plugins-linux-arm64-v1.4.0/tap         ../artifact/cni-plugins/tap
cp -a cni-plugins-linux-arm64-v1.4.0/tuning      ../artifact/cni-plugins/tuning
cp -a cni-plugins-linux-arm64-v1.4.0/vlan        ../artifact/cni-plugins/vlan
cp -a cni-plugins-linux-arm64-v1.4.0/vrf         ../artifact/cni-plugins/vrf

date
