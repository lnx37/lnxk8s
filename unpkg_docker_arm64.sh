#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg
mkdir -p artifact/docker

cd pkg

# wget -c "https://download.docker.com/linux/static/stable/aarch64/docker-24.0.9.tgz" -O docker_aarch64/docker-24.0.9.tgz
# wget -c "http://199.115.230.237:12345/kubernetes/docker_aarch64/docker-24.0.9.tgz" -O docker_aarch64/docker-24.0.9.tgz

[ -d docker ] && rm -rf docker
tar xzf docker_aarch64/docker-24.0.9.tgz

chown -R root:root docker

chmod +x docker/containerd
chmod +x docker/containerd-shim-runc-v2
chmod +x docker/ctr
chmod +x docker/docker
chmod +x docker/docker-init
chmod +x docker/docker-proxy
chmod +x docker/dockerd
chmod +x docker/runc

cp -a docker/containerd              ../artifact/docker/containerd
cp -a docker/containerd-shim-runc-v2 ../artifact/docker/containerd-shim-runc-v2
cp -a docker/ctr                     ../artifact/docker/ctr
cp -a docker/docker                  ../artifact/docker/docker
cp -a docker/docker-init             ../artifact/docker/docker-init
cp -a docker/docker-proxy            ../artifact/docker/docker-proxy
cp -a docker/dockerd                 ../artifact/docker/dockerd
cp -a docker/runc                    ../artifact/docker/runc

date
