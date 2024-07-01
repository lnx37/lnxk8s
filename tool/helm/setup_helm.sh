#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

helm repo list || true
helm repo add azure http://mirror.azure.cn/kubernetes/charts
helm repo add aliyun https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo list
helm repo update

date
