#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p artifact/containerd

cd artifact/containerd

# -- template
# wget -c "https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo" -O /etc/yum.repos.d/docker-ce.repo
# yum install containerd-io
# cat /usr/lib/systemd/system/containerd.service
#
# /usr/lib/systemd/system/containerd.service
cat <<\EOF >containerd.service
# Copyright The containerd Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target local-fs.target

[Service]
ExecStartPre=-/sbin/modprobe overlay
# ExecStart=/usr/bin/containerd
ExecStart=/usr/local/bin/containerd

Type=notify
Delegate=yes
KillMode=process
Restart=always
RestartSec=5
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNPROC=infinity
LimitCORE=infinity
LimitNOFILE=infinity
# Comment TasksMax if your systemd version does not supports it.
# Only systemd 226 and above support this version.
TasksMax=infinity
OOMScoreAdjust=-999

[Install]
WantedBy=multi-user.target
EOF

# /etc/containerd/config.toml
./containerd config default >config.toml
cp -a config.toml config.toml_bk_raw
sed -i "s|registry.k8s.io|registry.aliyuncs.com/google_containers|g" config.toml
sed -i "s|SystemdCgroup = false|SystemdCgroup = true|g" config.toml
#
# /etc/containerd/config.toml
# ---------------------------
#      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
#        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
#          endpoint=["https://docker.m.daocloud.io", "https://cagucih8.mirror.aliyuncs.com/"]
# ---------------------------
sed -i '/\[plugins."io.containerd.grpc.v1.cri".registry.mirrors\]/a\
\        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]\
\          endpoint=["https://docker.m.daocloud.io", "https://cagucih8.mirror.aliyuncs.com/"]' config.toml
diff -u config.toml_bk_raw config.toml || true

date
