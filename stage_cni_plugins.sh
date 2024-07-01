#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p artifact

cd artifact

cat <<\EOF >install_cni_plugins.sh
#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p /opt/cni/bin

cp -a cni-plugins/bandwidth   /opt/cni/bin/bandwidth
cp -a cni-plugins/bridge      /opt/cni/bin/bridge
cp -a cni-plugins/dhcp        /opt/cni/bin/dhcp
cp -a cni-plugins/dummy       /opt/cni/bin/dummy
cp -a cni-plugins/firewall    /opt/cni/bin/firewall
cp -a cni-plugins/host-device /opt/cni/bin/host-device
cp -a cni-plugins/host-local  /opt/cni/bin/host-local
cp -a cni-plugins/ipvlan      /opt/cni/bin/ipvlan
cp -a cni-plugins/loopback    /opt/cni/bin/loopback
cp -a cni-plugins/macvlan     /opt/cni/bin/macvlan
cp -a cni-plugins/portmap     /opt/cni/bin/portmap
cp -a cni-plugins/ptp         /opt/cni/bin/ptp
cp -a cni-plugins/sbr         /opt/cni/bin/sbr
cp -a cni-plugins/static      /opt/cni/bin/static
cp -a cni-plugins/tap         /opt/cni/bin/tap
cp -a cni-plugins/tuning      /opt/cni/bin/tuning
cp -a cni-plugins/vlan        /opt/cni/bin/vlan
cp -a cni-plugins/vrf         /opt/cni/bin/vrf

date
EOF

date
