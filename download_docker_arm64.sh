#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg

cd pkg

# https://github.com/moby/moby
# https://github.com/moby/moby/releases
# https://github.com/docker/docker-ce
# https://github.com/docker/docker-ce/releases
# https://download.docker.com/linux/static/stable/aarch64/
#
# wget -c "https://download.docker.com/linux/static/stable/aarch64/docker-19.03.9.tgz" -O docker-19.03.9.tgz
# wget -c "https://download.docker.com/linux/static/stable/aarch64/docker-24.0.9.tgz" -O docker-24.0.9.tgz
#
# mkdir -p docker_aarch64
# wget -c "http://199.115.230.237:12345/kubernetes/docker_aarch64/docker-19.03.9.tgz" -O docker_aarch64/docker-19.03.9.tgz
# wget -c "http://199.115.230.237:12345/kubernetes/docker_aarch64/docker-24.0.9.tgz" -O docker_aarch64/docker-24.0.9.tgz
mkdir -p docker_aarch64
wget -c "http://199.115.230.237:12345/kubernetes/docker_aarch64/docker-24.0.9.tgz" -O docker_aarch64/docker-24.0.9.tgz

date
