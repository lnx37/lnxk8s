#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p artifact/crio

cd artifact/crio

# -- template
# cat etc/10-crio.conf
#
# /etc/crio/crio.conf.d/10-crio.conf
cat <<EOF >10-crio.conf
[crio.image]
signature_policy = "/etc/crio/policy.json"

[crio.runtime]
default_runtime = "crun"

[crio.runtime.runtimes.crun]
runtime_path = "/usr/local/bin/crio-crun"
runtime_root = "/run/crun"
monitor_path = "/usr/local/bin/crio-conmon"
allowed_annotations = [
    "io.containers.trace-syscall",
]

[crio.runtime.runtimes.runc]
runtime_path = "/usr/local/bin/crio-runc"
runtime_root = "/run/runc"
monitor_path = "/usr/local/bin/crio-conmon"
EOF

# -- template
# cat contrib/policy.json
#
# /etc/crio/policy.json
cat <<EOF >policy.json
{ "default": [{ "type": "insecureAcceptAnything" }] }
EOF

# -- template
# cat contrib/registries.conf
#
# /etc/containers/registries.conf.d/registries.conf
cat <<EOF >registries.conf
unqualified-search-registries = ["docker.io", "quay.io"]

[[registry]]
location = "registry.k8s.io"

[[registry.mirror]]
location = "registry.aliyuncs.com/google_containers"
EOF

# -- template
# cat contrib/11-crio-ipv4-bridge.conflist
#
# /etc/cni/net.d/11-crio-ipv4-bridge.conflist
cat <<EOF >11-crio-ipv4-bridge.conflist
{
  "cniVersion": "1.0.0",
  "name": "crio",
  "plugins": [
    {
      "type": "bridge",
      "bridge": "cni0",
      "isGateway": true,
      "ipMasq": true,
      "hairpinMode": true,
      "ipam": {
        "type": "host-local",
        "routes": [
            { "dst": "0.0.0.0/0" }
        ],
        "ranges": [
            [{ "subnet": "10.85.0.0/16" }]
        ]
      }
    }
  ]
}
EOF

# -- template
# cat etc/crio-umount.conf
#
# /usr/local/share/oci-umount/oci-umount.d/crio-umount.conf
cat <<EOF >crio-umount.conf
# This contains a list of paths on host which will be unmounted inside
# container. (If they are mounted inside container).

# If there is a "/*" at the end, that means only mounts underneath that
# mounts (submounts) will be unmounted but top level mount will remain
# in place.
/var/run/containers/*
/var/lib/containers/storage/*
EOF

# -- template
# cat etc/crictl.yaml
#
# /etc/crictl.yaml
cat <<EOF >crictl.yaml
runtime-endpoint: "unix:///var/run/crio/crio.sock"
timeout: 0
debug: false
EOF

# -- template
# cat contrib/crio.service
#
# /usr/lib/systemd/system/crio.service
cat <<\EOF >crio.service
[Unit]
Description=Container Runtime Interface for OCI (CRI-O)
Documentation=https://github.com/cri-o/cri-o
Wants=network-online.target
Before=kubelet.service
After=network-online.target

[Service]
Type=notify
EnvironmentFile=-/etc/sysconfig/crio
Environment=GOTRACEBACK=crash
ExecStart=/usr/local/bin/crio \
          $CRIO_CONFIG_OPTIONS \
          $CRIO_RUNTIME_OPTIONS \
          $CRIO_STORAGE_OPTIONS \
          $CRIO_NETWORK_OPTIONS \
          $CRIO_METRICS_OPTIONS
ExecReload=/bin/kill -s HUP $MAINPID
TasksMax=infinity
LimitNOFILE=1048576
LimitNPROC=1048576
LimitCORE=infinity
OOMScoreAdjust=-999
TimeoutStartSec=0
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
Alias=cri-o.service
EOF

date
