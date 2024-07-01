#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

# container, mount
systemctl stop kubelet || true
crictl ps -q |xargs crictl stop >/dev/null 2>&1 || true
crictl ps -q |xargs crictl rm >/dev/null 2>&1 || true
crictl pods -q |xargs crictl stopp >/dev/null 2>&1 || true
crictl pods -q |xargs crictl rmp >/dev/null 2>&1 || true
df |grep "^tmpfs" |grep "/var/lib/kubelet" |awk '{print $NF}' |xargs umount >/dev/null 2>&1 || true

# kubelet
systemctl stop kubelet || true
rm -f /usr/lib/systemd/system/kubelet.service
systemctl daemon-reload
rm -rf /opt/kubernetes/kubelet
rm -rf /opt/kubernetes/manifests
rm -rf /var/lib/kubelet || true

# kube_proxy
systemctl stop kube-proxy || true
rm -f /usr/lib/systemd/system/kube-proxy.service
systemctl daemon-reload
rm -rf /opt/kubernetes/kube-proxy

# cni
rm -rf /etc/cni
rm -rf /etc/cni/net.d
rm -rf /opt/cni
rm -rf /opt/cni/bin
rm -rf /var/lib/cni

# containerd
systemctl stop containerd || true
rm -f /usr/lib/systemd/system/containerd.service
systemctl daemon-reload
rm -f /usr/local/bin/containerd
rm -f /usr/local/bin/containerd-shim
rm -f /usr/local/bin/containerd-shim-runc-v1
rm -f /usr/local/bin/containerd-shim-runc-v2
rm -f /usr/local/bin/containerd-stress
rm -f /usr/local/bin/ctr
rm -rf /etc/containerd
rm -rf /opt/containerd
rm -rf /var/lib/containerd
rm -rf /var/log/containers

# runc
rm -f /usr/local/bin/runc

# crictl
rm -f /usr/local/bin/crictl
rm -f /etc/crictl.yaml

# crio
systemctl stop crio || true
rm -f /usr/lib/systemd/system/crio.service
systemctl daemon-reload
rm -f /usr/local/bin/crictl
rm -f /usr/local/bin/crio
rm -f /usr/local/bin/crio-conmon
rm -f /usr/local/bin/crio-conmonrs
rm -f /usr/local/bin/crio-crun
rm -f /usr/local/bin/crio-runc
rm -f /usr/local/bin/pinns
rm -f /etc/crictl.yaml
rm -rf /etc/cni
rm -rf /etc/containers
rm -rf /etc/crio
rm -rf /usr/local/share/oci-umount
rm -rf /var/lib/crio
rm -rf /var/log/crio

# docker
systemctl stop docker || true
rm -f /usr/lib/systemd/system/docker.service
systemctl daemon-reload
rm -f /usr/local/bin/containerd
rm -f /usr/local/bin/containerd-shim-runc-v2
rm -f /usr/local/bin/ctr
rm -f /usr/local/bin/docker
rm -f /usr/local/bin/docker-init
rm -f /usr/local/bin/docker-proxy
rm -f /usr/local/bin/dockerd
rm -f /usr/local/bin/runc
rm -rf /etc/docker
rm -rf /var/lib/docker
rm -rf /var/lib/dockershim

# cri_dockerd
systemctl stop cri-docker || true
rm -f /usr/lib/systemd/system/cri-docker.service
rm -f /usr/lib/systemd/system/cri-docker.socket
systemctl daemon-reload
rm -f /usr/local/bin/cri-dockerd
rm -rf /var/lib/cri-dockerd

# flannel
rm -f /run/flannel/subnet.env
rm -rf /run/flannel

# calico
rm -rf /run/calico
rm -rf /var/lib/calico
rm -rf /var/log/calico

# ifconfig ipvs
ifconfig dummy0 down || true
ifconfig kube-ipvs0 down || true
ip link delete dummy0 || true
ip link delete kube-ipvs0 || true

# ifconfig docker
ifconfig docker0 down || true
ip link delete docker0 || true

# ifconfig flannel
ifconfig cni0 down || true
ifconfig flannel.1 down || true
ip link delete cni0 || true
ip link delete flannel.1 || true
for target in $(ifconfig -a |grep "^veth" |awk -F':' '{print $1}' |xargs); do ifconfig "$target" down; done
for target in $(ifconfig -a |grep "^veth" |awk -F':' '{print $1}' |xargs); do ip link delete "$target"; done

# ifconfig calico
ifconfig tunl0 down || true
ip link delete tunl0 || true
for target in $(ifconfig -a |grep "^cali" |awk -F':' '{print $1}' |xargs); do ifconfig "$target" down; done
for target in $(ifconfig -a |grep "^cali" |awk -F':' '{print $1}' |xargs); do ip link delete "$target"; done

# ifconfig cilium
ifconfig cilium_host down || true
ifconfig cilium_net down || true
ifconfig cilium_vxlan down || true
ip link delete cilium_host || true
ip link delete cilium_net || true
ip link delete cilium_vxlan || true
for target in $(ifconfig -a |grep "^lxc" |awk -F':' '{print $1}' |xargs); do ifconfig "$target" down; done
for target in $(ifconfig -a |grep "^lxc" |awk -F':' '{print $1}' |xargs); do ip link delete "$target"; done

# ipvs
ipvsadm --clear || true

# iptables
iptables -F && iptables -F -t nat && iptables -F -t mangle && iptables -X

# nerdctl
rm -f /etc/cni/net.d/nerdctl-bridge.conflist
rm -f /usr/local/bin/nerdctl
rm -rf /var/lib/nerdctl
ifconfig nerdctl0 down || true
ip link delete nerdctl0 || true

# misc
rm -rf /var/log/containers
rm -rf /var/log/pods

date
