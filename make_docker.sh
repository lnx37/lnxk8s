#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p artifact/docker

cd artifact/docker

# /etc/docker/daemon.json
cat <<EOF >daemon.json
{
  "exec-opts": [
    "native.cgroupdriver=systemd"
  ],
  "registry-mirrors": [
    "https://docker.m.daocloud.io",
    "https://cagucih8.mirror.aliyuncs.com/"
  ]
}
EOF

# -- template
# wget -c "https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo" -O /etc/yum.repos.d/docker-ce.repo
# yum install docker-ce
# cat /usr/lib/systemd/system/docker.service
#
# /usr/lib/systemd/system/docker.service
cat <<\EOF >docker.service
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target docker.socket firewalld.service containerd.service time-set.target
Wants=network-online.target containerd.service
# Requires=docker.socket

[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
# ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
ExecStart=/usr/local/bin/dockerd
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutStartSec=0
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
LimitNPROC=infinity
LimitCORE=infinity
# Older systemd versions default to a LimitNOFILE of 1024:1024, which is insufficient for many
# applications including dockerd itself and will be inherited. Raise the hard limit, while
# preserving the soft limit for select(2).
LimitNOFILE=1024:524288

# Comment TasksMax if your systemd version does not support it.
# Only systemd 226 and above support this option.
TasksMax=infinity

# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes

# kill only the docker process, not all processes in the cgroup
KillMode=process
OOMScoreAdjust=-500

[Install]
WantedBy=multi-user.target
EOF

date
