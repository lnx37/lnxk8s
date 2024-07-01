#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p artifact/cri-dockerd

cd artifact/cri-dockerd

# -- template
# wget -c "https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.9/cri-dockerd-0.3.9-3.el7.x86_64.rpm" -O cri-dockerd-0.3.9-3.el7.x86_64.rpm
# yum install cri-dockerd
# cat /usr/lib/systemd/system/cri-docker.service
#
# /usr/lib/systemd/system/cri-docker.service
cat <<\EOF >cri-docker.service
[Unit]
Description=CRI Interface for Docker Application Container Engine
Documentation=https://docs.mirantis.com
After=network-online.target firewalld.service docker.service
Wants=network-online.target
# Requires=cri-docker.socket

[Service]
Type=notify
# ExecStart=/usr/bin/cri-dockerd --container-runtime-endpoint fd://
ExecStart=/usr/local/bin/cri-dockerd --pod-infra-container-image=registry.aliyuncs.com/google_containers/pause:3.6
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutSec=0
RestartSec=2
Restart=always

# Note that StartLimit* options were moved from "Service" to "Unit" in systemd 229.
# Both the old, and new location are accepted by systemd 229 and up, so using the old location
# to make them work for either version of systemd.
StartLimitBurst=3

# Note that StartLimitInterval was renamed to StartLimitIntervalSec in systemd 230.
# Both the old, and new name are accepted by systemd 230 and up, so using the old name to make
# this option work for either version of systemd.
StartLimitInterval=60s

# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity

# Comment TasksMax if your systemd version does not support it.
# Only systemd 226 and above support this option.
TasksMax=infinity
Delegate=yes
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

date
