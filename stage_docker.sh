#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p artifact

cd artifact

cat <<\EOF >install_docker.sh
#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p /etc/docker

cp -a docker/containerd              /usr/local/bin/containerd
cp -a docker/containerd-shim-runc-v2 /usr/local/bin/containerd-shim-runc-v2
cp -a docker/ctr                     /usr/local/bin/ctr
cp -a docker/daemon.json             /etc/docker/daemon.json
cp -a docker/docker                  /usr/local/bin/docker
cp -a docker/docker-init             /usr/local/bin/docker-init
cp -a docker/docker-proxy            /usr/local/bin/docker-proxy
cp -a docker/docker.service          /usr/lib/systemd/system/docker.service
cp -a docker/dockerd                 /usr/local/bin/dockerd
cp -a docker/runc                    /usr/local/bin/runc

systemctl daemon-reload
systemctl enable docker
systemctl restart docker

date
EOF

date
