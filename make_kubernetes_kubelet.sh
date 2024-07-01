#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source env.sh
echo "${KUBE_APISERVER_IP}"
echo "${CONTAINER_RUNTIME}"

mkdir -p artifact/kubernetes/kubelet

cd artifact/kubernetes/kubelet

# -- kubeadm
# cat /etc/kubernetes/kubelet.conf
#
# -- refer
# https://kubernetes.io/docs/setup/best-practices/certificates/
# https://kubernetes.io/docs/reference/kubectl/generated/kubectl_config/
# https://kubernetes.io/docs/reference/access-authn-authz/bootstrap-tokens/
# https://kubernetes.io/docs/reference/access-authn-authz/bootstrap-tokens/#token-format
# https://kubernetes.io/docs/reference/access-authn-authz/kubelet-tls-bootstrapping/
# https://kubernetes.io/docs/reference/access-authn-authz/kubelet-tls-bootstrapping/#kubelet-configuration
# https://github.com/kubernetes/kubernetes/blob/master/cluster/common.sh
# https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/05-kubernetes-configuration-files.md
#
# /opt/kubernetes/kubelet/kubelet-bootstrap.kubeconfig
KUBECONFIG="./kubelet-bootstrap.kubeconfig"
KUBE_APISERVER="https://${KUBE_APISERVER_IP}:6443"
[ -f "$KUBECONFIG" ] && rm -f "$KUBECONFIG"
kubectl config set-cluster kubernetes \
  --certificate-authority=../ca.pem \
  --embed-certs=true \
  --kubeconfig="$KUBECONFIG" \
  --server="${KUBE_APISERVER}"
kubectl config set-credentials system:node:hostname \
  --kubeconfig="$KUBECONFIG" \
  --token=abcdef.0123456789abcdef
kubectl config set-context system:node:hostname@kubernetes \
  --cluster=kubernetes \
  --kubeconfig="$KUBECONFIG" \
  --user=system:node:hostname
kubectl config use-context system:node:hostname@kubernetes --kubeconfig="$KUBECONFIG"

# -- kubeadm
# cat /var/lib/kubelet/config.yaml
#
# -- changelog
# modify, clientCAFile: /etc/kubernetes/pki/ca.crt
# modify, staticPodPath: /etc/kubernetes/manifests
#
# -- refer
# https://kubernetes.io/docs/reference/config-api/kubelet-config.v1beta1/
#
# /opt/kubernetes/kubelet/kubelet-config.yml
cat <<EOF >kubelet-config.yml
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    cacheTTL: 0s
    enabled: true
  x509:
    # clientCAFile: /etc/kubernetes/pki/ca.crt
    clientCAFile: /opt/kubernetes/ca.pem
authorization:
  mode: Webhook
  webhook:
    cacheAuthorizedTTL: 0s
    cacheUnauthorizedTTL: 0s
cgroupDriver: systemd
clusterDNS:
- 10.96.0.10
clusterDomain: cluster.local
containerRuntimeEndpoint: ""
cpuManagerReconcilePeriod: 0s
evictionPressureTransitionPeriod: 0s
fileCheckFrequency: 0s
healthzBindAddress: 127.0.0.1
healthzPort: 10248
httpCheckFrequency: 0s
imageMinimumGCAge: 0s
kind: KubeletConfiguration
logging:
  flushFrequency: 0
  options:
    json:
      infoBufferSize: "0"
  verbosity: 0
memorySwap: {}
nodeStatusReportFrequency: 0s
nodeStatusUpdateFrequency: 0s
rotateCertificates: true
runtimeRequestTimeout: 0s
shutdownGracePeriod: 0s
shutdownGracePeriodCriticalPods: 0s
# staticPodPath: /etc/kubernetes/manifests
staticPodPath: /opt/kubernetes/manifests
streamingConnectionIdleTimeout: 0s
syncFrequency: 0s
volumeStatsAggPeriod: 0s
EOF

if [ "${CONTAINER_RUNTIME}" = "containerd" ]; then
  CONTAINER_RUNTIME_ENDPOINT="unix:///run/containerd/containerd.sock"
fi
if [ "${CONTAINER_RUNTIME}" = "crio" ]; then
  CONTAINER_RUNTIME_ENDPOINT="unix:///run/crio/crio.sock"
fi
if [ "${CONTAINER_RUNTIME}" = "docker" ]; then
  CONTAINER_RUNTIME_ENDPOINT="unix:///run/cri-dockerd.sock"
fi

# -- kubeadm
# ps -ef |grep "kubelet"
#
# -- changelog
# modify, --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock
#
# -- refer
# https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/
#
# /opt/kubernetes/kubelet/kubelet.conf
cat <<EOF >kubelet.conf
KUBELET_OPTS=" \\
  --bootstrap-kubeconfig=/opt/kubernetes/kubelet/kubelet-bootstrap.kubeconfig \\
  --config=/opt/kubernetes/kubelet/kubelet-config.yml \\
  --container-runtime-endpoint=${CONTAINER_RUNTIME_ENDPOINT} \\
  --kubeconfig=/opt/kubernetes/kubelet/kubelet.kubeconfig \\
  --pod-infra-container-image=registry.aliyuncs.com/google_containers/pause:3.9 \\
"
EOF

# -- kubeadm
# yum install kubelet
# cat /usr/lib/systemd/system/kubelet.service
#
# /usr/lib/systemd/system/kubelet.service
cat <<\EOF >kubelet.service
[Unit]
Description=kubelet: The Kubernetes Node Agent
Documentation=https://kubernetes.io/docs/
Wants=network-online.target
# After=network-online.target
After=network-online.target containerd.service cri-docker.service

[Service]
EnvironmentFile=/opt/kubernetes/kubelet/kubelet.conf
# ExecStart=/usr/bin/kubelet
ExecStart=/opt/kubernetes/kubelet/kubelet $KUBELET_OPTS
Restart=always
StartLimitInterval=0
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

date
