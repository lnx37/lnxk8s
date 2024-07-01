#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p artifact

cd artifact

cat <<\EOF >install_crictl.sh
#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

cp -a crictl/crictl.yaml /etc/crictl.yaml
cp -a crictl/crictl      /usr/local/bin/crictl

date
EOF

date
