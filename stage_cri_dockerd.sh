#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p artifact

cd artifact

cat <<\EOF >install_cri_dockerd.sh
#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

cp -a cri-dockerd/cri-docker.service /usr/lib/systemd/system/cri-docker.service
cp -a cri-dockerd/cri-dockerd        /usr/local/bin/cri-dockerd

systemctl daemon-reload
systemctl enable cri-docker
systemctl restart cri-docker

date
EOF

date
