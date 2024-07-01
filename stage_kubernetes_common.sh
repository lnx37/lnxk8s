#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p artifact

cd artifact

cat <<\EOF >install_kubernetes_common.sh
#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

# conntrack-tools
# nfs-utils
# socat
if (which yum >/dev/null 2>&1); then
  yum install conntrack -y -q
  yum install ipset -y -q
  yum install ipvsadm -y -q
fi

# socat
if (which apt >/dev/null 2>&1); then
  apt update >/dev/null 2>&1
  apt install conntrack -y >/dev/null 2>&1
  apt install ipset -y >/dev/null 2>&1
  apt install ipvsadm -y >/dev/null 2>&1
fi

# overlay
# systemctl restart systemd-modules-load
cat <<EOT >/etc/modules-load.d/kubernetes.conf
br_netfilter
EOT
modprobe br_netfilter

# vm.swappiness=0
# sysctl --system
cat <<EOT >/etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables=1
net.bridge.bridge-nf-call-iptables=1
net.ipv4.ip_forward=1
EOT
sysctl -p /etc/sysctl.d/kubernetes.conf

date
EOF

date
