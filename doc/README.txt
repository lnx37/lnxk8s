-- intro
bootstrap a kubernetes cluster in 5 minutes



-- requirement
2c2g at least
2c4g or 2c2g*2 would be better



-- usage
vim env.sh
bash bootstrap.sh



-- upstream
updated on 202406

built around with,
calico         v3.27.0  (20231216) (latest:v3.28.0:(20240511)) https://github.com/projectcalico/calico/releases
cfssl          v1.6.4   (20230411) (latest:v1.6.5 :(20240306)) https://github.com/cloudflare/cfssl/releases
cilium         v1.15.1  (20240215) (latest:v1.15.5:(20240515)) https://github.com/cilium/cilium/releases
cni-plugins    v1.4.0   (20231205) (latest:v1.5.0 :(20240520)) https://github.com/containernetworking/plugins/releases
containerd     v1.6.28  (20240201) (latest:v1.7.18:(20240605)) https://github.com/containerd/containerd/releases
coredns        v1.10.1  (20230207) (latest:v1.11.1:(20231019)) https://github.com/kubernetes/kubernetes/tree/v1.28.10/cluster/addons/dns/coredns
cri-dockerd    v0.3.9   (20240102) (latest:v0.3.14:(20240514)) https://github.com/Mirantis/cri-dockerd/releases
crictl         v1.28.0  (20230814) (latest:v1.30.0:(20240418)) https://github.com/kubernetes-sigs/cri-tools/releases
crio           v1.30.1  (20240518) (latest:v1.30.2:(20240603)) https://github.com/cri-o/cri-o/releases
dashboard      v7.0.1   (20240307) (latest:v7.5.0 :(20240604)) https://github.com/kubernetes/dashboard/releases
docker         v24.0.9  (20240201) (latest:v26.1.4:(20240606)) https://github.com/moby/moby/releases
etcd           v3.5.12  (20240131) (latest:v3.5.14:(20240530)) https://github.com/etcd-io/etcd/releases
flannel        v0.24.2  (20240119) (latest:v0.25.3:(20240531)) https://github.com/flannel-io/flannel/releases
kubernetes     v1.28.10 (20240515) (latest:v1.30.1:(20240515)) https://github.com/kubernetes/kubernetes/releases
metrics-server v0.7.0   (20240123) (latest:v0.7.1 :(20240327)) https://github.com/kubernetes-sigs/metrics-server/releases
runc           v1.1.11  (20240102) (latest:v1.1.12:(20240201)) https://github.com/opencontainers/runc/releases

but also supports,
calico         v3.27.0
cfssl          v1.2.0, v1.6.4 (*)
cilium         v1.15.1
cni-plugins    v1.4.0
containerd     v1.6.28
coredns        v1.9.4, v1.10.1 (*)
cri-dockerd    v0.3.9
crictl         v1.28.0
crio           v1.30.1
dashboard      v2.7.0, v7.0.1 (*)
docker         v19.03.9, v24.0.9 (*)
etcd           v3.4.9, v3.4.30, v3.5.12 (*)
flannel        v0.24.2
kubernetes     v1.18.20, v1.19.16, v1.20.15, v1.21.14, v1.22.17, v1.23.17
kubernetes     v1.24.17, v1.25.14, v1.26.9, v1.27.6, v1.28.10 (*), v1.29.4, v1.30.1
metrics-server v0.7.0
runc           v1.1.11



-- tested on
os_arch, os_release,                               os_image,                         kernel_version
amd64,   CentOS Linux release 7.9.2009 (Core),     CentOS Linux 7 (Core),            3.10.0-1160.105.1.el7.x86_64
amd64,   CentOS Linux release 8.5.2111,            CentOS Linux 8,                   4.18.0-348.7.1.el8_5.x86_64
amd64,   CentOS Stream release 8,                  CentOS Stream 8,                  4.18.0-529.el8.x86_64
amd64,   CentOS Stream release 9,                  CentOS Stream 9,                  5.14.0-407.el9.x86_64
amd64,   Debian GNU/Linux 10.9 (buster),           Debian GNU/Linux 10 (buster),     4.19.0-16-amd64
amd64,   Debian GNU/Linux 11.8 (bullseye),         Debian GNU/Linux 11 (bullseye),   5.10.0-27-amd64
amd64,   Debian GNU/Linux 12.4 (bookworm),         Debian GNU/Linux 12 (bookworm),   6.1.0-17-amd64
amd64,   Rocky Linux release 8.9 (Green Obsidian), Rocky Linux 8.9 (Green Obsidian), 4.18.0-513.9.1.el8_9.x86_64
amd64,   Rocky Linux release 9.3 (Blue Onyx),      Rocky Linux 9.3 (Blue Onyx),      5.14.0-362.13.1.el9_3.x86_64
amd64,   Ubuntu 20.04.6 LTS (Focal Fossa),         Ubuntu 20.04.6 LTS,               5.4.0-169-generic
amd64,   Ubuntu 22.04.3 LTS (Jammy Jellyfish),     Ubuntu 22.04.3 LTS,               5.15.0-92-generic
arm64,   CentOS Linux release 7.9.2009 (AltArch),  CentOS Linux 7 (AltArch),         4.18.0-348.20.1.el7.aarch64



-- big picture
bootstrap.sh
|-- init.sh
|   |-- init_ssh.sh
|   `-- init_check.sh
|-- download.sh
|   |-- download_cfssl.sh
|   |-- download_etcd.sh
|   |-- download_cni_plugins.sh
|   |-- download_containerd.sh
|   |-- download_runc.sh
|   |-- download_crictl.sh
|   |-- download_crio.sh
|   |-- download_docker.sh
|   |-- download_cri_dockerd.sh
|   `-- download_kubernetes.sh
|-- unpkg.sh
|   |-- unpkg_cfssl.sh
|   |-- unpkg_etcd.sh
|   |-- unpkg_cni_plugins.sh
|   |-- unpkg_containerd.sh
|   |-- unpkg_runc.sh
|   |-- unpkg_crictl.sh
|   |-- unpkg_crio.sh
|   |-- unpkg_docker.sh
|   |-- unpkg_cri_dockerd.sh
|   `-- unpkg_kubernetes.sh
|-- make.sh
|   |-- make_etcd.sh
|   |-- make_containerd.sh
|   |-- make_crictl.sh
|   |-- make_crio.sh
|   |-- make_docker.sh
|   |-- make_cri_dockerd.sh
|   |-- make_kubernetes_common.sh
|   |-- make_kubernetes_kubectl.sh
|   |-- make_kubernetes_kube_apiserver.sh
|   |-- make_kubernetes_kube_controller_manager.sh
|   |-- make_kubernetes_kube_scheduler.sh
|   |-- make_kubernetes_kubelet.sh
|   `-- make_kubernetes_kube_proxy.sh
|-- stage.sh
|   |-- stage_etcd.sh
|   |-- stage_cni_plugins.sh
|   |-- stage_containerd.sh
|   |-- stage_runc.sh
|   |-- stage_crictl.sh
|   |-- stage_crio.sh
|   |-- stage_docker.sh
|   |-- stage_cri_dockerd.sh
|   |-- stage_kubectl.sh
|   |-- stage_kubernetes_common.sh
|   |-- stage_kubernetes_kubectl.sh
|   |-- stage_kubernetes_kube_apiserver.sh
|   |-- stage_kubernetes_kube_controller_manager.sh
|   |-- stage_kubernetes_kube_scheduler.sh
|   |-- stage_kubernetes_kubelet.sh
|   `-- stage_kubernetes_kube_proxy.sh
|-- install.sh
|   |-- install_kubectl.sh
|   |-- install_etcd.sh
|   |-- install_kubernetes_master.sh
|   |   |-- install_kubernetes_common.sh
|   |   |-- install_kubernetes_kubectl.sh
|   |   |-- install_kubernetes_kube_apiserver.sh
|   |   |-- install_kubernetes_kube_controller_manager.sh
|   |   `-- install_kubernetes_kube_scheduler.sh
|   |-- install_kubernetes_worker.sh
|   |   |-- install_cni_plugins.sh
|   |   |-- install_containerd.sh
|   |   |-- install_runc.sh
|   |   |-- install_crictl.sh
|   |   |-- install_crio.sh
|   |   |-- install_docker.sh
|   |   |-- install_cri_dockerd.sh
|   |   |-- install_kubernetes_common.sh
|   |   |-- install_kubernetes_kubelet.sh
|   |   `-- install_kubernetes_kube_proxy.sh
|   |-- addon/calico/install_calico.sh
|   |-- addon/cilium/install_cilium.sh
|   |-- addon/flannel/install_flannel.sh
|   |-- addon/coredns/install_coredns.sh
|   `-- addon/metrics_server/install_metrics_server.sh
|-- setup.sh
|-- taint.sh
`-- uninstall.sh
    |-- uninstall_common.sh
    |-- uninstall_etcd.sh
    |-- uninstall_kubernetes_master.sh
    |-- uninstall_kubernetes_worker.sh
    `-- uninstall_misc.sh
