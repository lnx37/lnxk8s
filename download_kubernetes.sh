#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source env.sh
echo "${KUBERNETES_VERSION}"

mkdir -p pkg

cd pkg

# https://github.com/kubernetes/kubernetes
# https://github.com/kubernetes/kubernetes/releases
# https://github.com/kubernetes/kubernetes/tree/master/CHANGELOG
# https://kubernetes.io/releases/download/
#
# wget -c "https://dl.k8s.io/v1.18.20/kubernetes-server-linux-amd64.tar.gz" -O kubernetes-server-linux-amd64.tar.gz
# wget -c "https://dl.k8s.io/v1.19.16/kubernetes-server-linux-amd64.tar.gz" -O kubernetes-server-linux-amd64.tar.gz
# wget -c "https://dl.k8s.io/v1.20.15/kubernetes-server-linux-amd64.tar.gz" -O kubernetes-server-linux-amd64.tar.gz
# wget -c "https://dl.k8s.io/v1.21.14/kubernetes-server-linux-amd64.tar.gz" -O kubernetes-server-linux-amd64.tar.gz
# wget -c "https://dl.k8s.io/v1.22.17/kubernetes-server-linux-amd64.tar.gz" -O kubernetes-server-linux-amd64.tar.gz
# wget -c "https://dl.k8s.io/v1.23.17/kubernetes-server-linux-amd64.tar.gz" -O kubernetes-server-linux-amd64.tar.gz
# wget -c "https://dl.k8s.io/v1.24.17/kubernetes-server-linux-amd64.tar.gz" -O kubernetes-server-linux-amd64.tar.gz
# wget -c "https://dl.k8s.io/v1.25.14/kubernetes-server-linux-amd64.tar.gz" -O kubernetes-server-linux-amd64.tar.gz
# wget -c "https://dl.k8s.io/v1.26.9/kubernetes-server-linux-amd64.tar.gz" -O kubernetes-server-linux-amd64.tar.gz
# wget -c "https://dl.k8s.io/v1.27.6/kubernetes-server-linux-amd64.tar.gz" -O kubernetes-server-linux-amd64.tar.gz
# wget -c "https://dl.k8s.io/v1.28.10/kubernetes-server-linux-amd64.tar.gz" -O kubernetes-server-linux-amd64.tar.gz
# wget -c "https://dl.k8s.io/v1.29.4/kubernetes-server-linux-amd64.tar.gz" -O kubernetes-server-linux-amd64.tar.gz
# wget -c "https://dl.k8s.io/v1.30.1/kubernetes-server-linux-amd64.tar.gz" -O kubernetes-server-linux-amd64.tar.gz
#
# mkdir -p kubernetes_v1.18.20
# wget -c "http://199.115.230.237:12345/kubernetes/kubernetes_v1.18.20/kubernetes-server-linux-amd64.tar.gz" -O kubernetes_v1.18.20/kubernetes-server-linux-amd64.tar.gz
# mkdir -p kubernetes_v1.19.16
# wget -c "http://199.115.230.237:12345/kubernetes/kubernetes_v1.19.16/kubernetes-server-linux-amd64.tar.gz" -O kubernetes_v1.19.16/kubernetes-server-linux-amd64.tar.gz
# mkdir -p kubernetes_v1.20.15
# wget -c "http://199.115.230.237:12345/kubernetes/kubernetes_v1.20.15/kubernetes-server-linux-amd64.tar.gz" -O kubernetes_v1.20.15/kubernetes-server-linux-amd64.tar.gz
# mkdir -p kubernetes_v1.21.14
# wget -c "http://199.115.230.237:12345/kubernetes/kubernetes_v1.21.14/kubernetes-server-linux-amd64.tar.gz" -O kubernetes_v1.21.14/kubernetes-server-linux-amd64.tar.gz
# mkdir -p kubernetes_v1.22.17
# wget -c "http://199.115.230.237:12345/kubernetes/kubernetes_v1.22.17/kubernetes-server-linux-amd64.tar.gz" -O kubernetes_v1.22.17/kubernetes-server-linux-amd64.tar.gz
# mkdir -p kubernetes_v1.23.17
# wget -c "http://199.115.230.237:12345/kubernetes/kubernetes_v1.23.17/kubernetes-server-linux-amd64.tar.gz" -O kubernetes_v1.23.17/kubernetes-server-linux-amd64.tar.gz
# mkdir -p kubernetes_v1.24.17
# wget -c "http://199.115.230.237:12345/kubernetes/kubernetes_v1.24.17/kubernetes-server-linux-amd64.tar.gz" -O kubernetes_v1.24.17/kubernetes-server-linux-amd64.tar.gz
# mkdir -p kubernetes_v1.25.14
# wget -c "http://199.115.230.237:12345/kubernetes/kubernetes_v1.25.14/kubernetes-server-linux-amd64.tar.gz" -O kubernetes_v1.25.14/kubernetes-server-linux-amd64.tar.gz
# mkdir -p kubernetes_v1.26.9
# wget -c "http://199.115.230.237:12345/kubernetes/kubernetes_v1.26.9/kubernetes-server-linux-amd64.tar.gz" -O kubernetes_v1.26.9/kubernetes-server-linux-amd64.tar.gz
# mkdir -p kubernetes_v1.27.6
# wget -c "http://199.115.230.237:12345/kubernetes/kubernetes_v1.27.6/kubernetes-server-linux-amd64.tar.gz" -O kubernetes_v1.27.6/kubernetes-server-linux-amd64.tar.gz
# mkdir -p kubernetes_v1.28.10
# wget -c "http://199.115.230.237:12345/kubernetes/kubernetes_v1.28.10/kubernetes-server-linux-amd64.tar.gz" -O kubernetes_v1.28.10/kubernetes-server-linux-amd64.tar.gz
# mkdir -p kubernetes_v1.29.4
# wget -c "http://199.115.230.237:12345/kubernetes/kubernetes_v1.29.4/kubernetes-server-linux-amd64.tar.gz" -O kubernetes_v1.29.4/kubernetes-server-linux-amd64.tar.gz
# mkdir -p kubernetes_v1.30.1
# wget -c "http://199.115.230.237:12345/kubernetes/kubernetes_v1.30.1/kubernetes-server-linux-amd64.tar.gz" -O kubernetes_v1.30.1/kubernetes-server-linux-amd64.tar.gz
#
# kubernetes_version="v1.18.20"
# kubernetes_version="v1.19.16"
# kubernetes_version="v1.20.15"
# kubernetes_version="v1.21.14"
# kubernetes_version="v1.22.17"
# kubernetes_version="v1.23.17"
# kubernetes_version="v1.24.17"
# kubernetes_version="v1.25.14"
# kubernetes_version="v1.26.9"
# kubernetes_version="v1.27.6"
# kubernetes_version="v1.28.10"
# kubernetes_version="v1.29.4"
# kubernetes_version="v1.30.1"
mkdir -p "kubernetes_${KUBERNETES_VERSION}"
wget -c "http://199.115.230.237:12345/kubernetes/kubernetes_${KUBERNETES_VERSION}/kubernetes-server-linux-amd64.tar.gz" -O "kubernetes_${KUBERNETES_VERSION}/kubernetes-server-linux-amd64.tar.gz"

date
