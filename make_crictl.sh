#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p artifact/crictl

cd artifact/crictl

# -- template
# crictl config --set runtime-endpoint=unix:///run/containerd/containerd.sock
# crictl config --set image-endpoint=unix:///run/containerd/containerd.sock
# cat /etc/crictl.yaml
#
# -- changelog
# modify, runtime-endpoint: ""
# modify, image-endpoint: ""
#
# /etc/crictl.yaml
cat <<EOF >crictl.yaml
runtime-endpoint: "unix:///run/containerd/containerd.sock"
image-endpoint: "unix:///run/containerd/containerd.sock"
timeout: 0
debug: false
pull-image-on-create: false
disable-pull-on-run: false
EOF

date
