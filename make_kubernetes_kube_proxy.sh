#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source env.sh
echo "${KUBE_APISERVER_IP}"
echo "${KUBE_PROXY_MODE}"

mkdir -p artifact/kubernetes/kube-proxy

cd artifact/kubernetes/kube-proxy

# -- template
# cfssl print-defaults config
# cfssl print-defaults csr
#
# -- refer
# https://kubernetes.io/docs/setup/best-practices/certificates/
# https://kubernetes.io/docs/tasks/administer-cluster/certificates/
# https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/04-certificate-authority.md
cat <<EOF >kube-proxy-csr.json
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CHANGEME",
      "ST": "CHANGEME",
      "L": "CHANGEME",
      "O": "system:node-proxier",
      "OU": "CHANGEME"
    }
  ]
}
EOF

# -- input
# ../ca.pem
# ../ca-key.pem
# ../ca-config.json
# kube-proxy-csr.json
#
# -- output
# kube-proxy-key.pem
# kube-proxy.csr
# kube-proxy.pem
cfssl gencert \
  -ca=../ca.pem \
  -ca-key=../ca-key.pem \
  -config=../ca-config.json \
  -profile=kubernetes \
  kube-proxy-csr.json |cfssljson -bare kube-proxy

# -- kubeadm
# kubectl exec -it kube-proxy-hmt4d -n kube-system -- cat /var/lib/kube-proxy/kubeconfig.conf
#
# -- refer
# https://kubernetes.io/docs/setup/best-practices/certificates/
# https://kubernetes.io/docs/reference/kubectl/generated/kubectl_config/
# https://kubernetes.io/docs/reference/access-authn-authz/kubelet-tls-bootstrapping/
# https://github.com/kubernetes/kubernetes/blob/master/cluster/common.sh
# https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/05-kubernetes-configuration-files.md
#
# /opt/kubernetes/kube-proxy/kube-proxy.kubeconfig
KUBECONFIG="./kube-proxy.kubeconfig"
KUBE_APISERVER="https://${KUBE_APISERVER_IP}:6443"
[ -f "$KUBECONFIG" ] && rm -f "$KUBECONFIG"
kubectl config set-cluster default \
  --certificate-authority=../ca.pem \
  --embed-certs=true \
  --kubeconfig="$KUBECONFIG" \
  --server="${KUBE_APISERVER}"
kubectl config set-credentials default \
  --client-certificate=./kube-proxy.pem \
  --client-key=./kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig="$KUBECONFIG"
kubectl config set-context default \
  --cluster=default \
  --kubeconfig="$KUBECONFIG" \
  --user=default
kubectl config use-context default --kubeconfig="$KUBECONFIG"

# -- kubeadm
# kubectl exec -it kube-proxy-hmt4d -n kube-system -- cat /var/lib/kube-proxy/config.conf
#
# -- changelog
# modify, kubeconfig: /var/lib/kube-proxy/kubeconfig.conf
# modify, mode: ""
#
# -- option
# ipvs:
#   strictARP: true
#
# -- refer
# https://kubernetes.io/docs/reference/config-api/kube-proxy-config.v1alpha1/
# https://kubernetes.io/docs/reference/config-api/kube-proxy-config.v1alpha1/#kubeproxy-config-k8s-io-v1alpha1-ProxyMode
#
# /opt/kubernetes/kube-proxy/kube-proxy-config.yml
cat <<EOF >kube-proxy-config.yml
apiVersion: kubeproxy.config.k8s.io/v1alpha1
bindAddress: 0.0.0.0
bindAddressHardFail: false
clientConnection:
  acceptContentTypes: ""
  burst: 0
  contentType: ""
  # kubeconfig: /var/lib/kube-proxy/kubeconfig.conf
  kubeconfig: /opt/kubernetes/kube-proxy/kube-proxy.kubeconfig
  qps: 0
clusterCIDR: 10.244.0.0/16
configSyncPeriod: 0s
conntrack:
  maxPerCore: null
  min: null
  tcpCloseWaitTimeout: null
  tcpEstablishedTimeout: null
detectLocal:
  bridgeInterface: ""
  interfaceNamePrefix: ""
detectLocalMode: ""
enableProfiling: false
healthzBindAddress: ""
hostnameOverride: ""
iptables:
  localhostNodePorts: null
  masqueradeAll: false
  masqueradeBit: null
  minSyncPeriod: 0s
  syncPeriod: 0s
ipvs:
  excludeCIDRs: null
  minSyncPeriod: 0s
  scheduler: ""
  strictARP: false
  syncPeriod: 0s
  tcpFinTimeout: 0s
  tcpTimeout: 0s
  udpTimeout: 0s
kind: KubeProxyConfiguration
logging:
  flushFrequency: 0
  options:
    json:
      infoBufferSize: "0"
  verbosity: 0
metricsBindAddress: ""
# mode: ""
mode: "${KUBE_PROXY_MODE}"
nodePortAddresses: null
oomScoreAdj: null
portRange: ""
showHiddenMetricsForVersion: ""
winkernel:
  enableDSR: false
  forwardHealthCheckVip: false
  networkName: ""
  rootHnsEndpointName: ""
  sourceVip: ""
EOF

# -- kubeadm
# ps -ef |grep "kube-proxy"
#
# -- changelog
# remove, --hostname-override=izwz9cr13vz9wwgxwlpzrdz
#
# -- refer
# https://kubernetes.io/docs/reference/command-line-tools-reference/kube-proxy/
#
# /opt/kubernetes/kube-proxy/kube-proxy.conf
cat <<EOF >kube-proxy.conf
KUBE_PROXY_OPTS=" \\
  --config=/opt/kubernetes/kube-proxy/kube-proxy-config.yml \\
"
EOF

# /usr/lib/systemd/system/kube-proxy.service
cat <<\EOF >kube-proxy.service
[Unit]
Description=Kubernetes kube-proxy
Documentation=https://kubernetes.io/docs/
Wants=network-online.target
After=network-online.target containerd.service cri-docker.service docker.service

[Service]
EnvironmentFile=/opt/kubernetes/kube-proxy/kube-proxy.conf
ExecStart=/opt/kubernetes/kube-proxy/kube-proxy $KUBE_PROXY_OPTS
Restart=always

[Install]
WantedBy=multi-user.target
EOF

date
