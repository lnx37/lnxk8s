#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg
mkdir -p artifact/cfssl

cd pkg

# wget -c "https://github.com/cloudflare/cfssl/releases/download/v1.6.4/cfssl-certinfo_1.6.4_linux_arm64" -O cfssl-certinfo_1.6.4_linux_arm64
# wget -c "https://github.com/cloudflare/cfssl/releases/download/v1.6.4/cfssl_1.6.4_linux_arm64"          -O cfssl_1.6.4_linux_arm64
# wget -c "https://github.com/cloudflare/cfssl/releases/download/v1.6.4/cfssljson_1.6.4_linux_arm64"      -O cfssljson_1.6.4_linux_arm64
# wget -c "http://199.115.230.237:12345/kubernetes/cfssl-certinfo_1.6.4_linux_arm64" -O cfssl-certinfo_1.6.4_linux_arm64
# wget -c "http://199.115.230.237:12345/kubernetes/cfssl_1.6.4_linux_arm64"          -O cfssl_1.6.4_linux_arm64
# wget -c "http://199.115.230.237:12345/kubernetes/cfssljson_1.6.4_linux_arm64"      -O cfssljson_1.6.4_linux_arm64

chown root:root cfssl-certinfo_1.6.4_linux_arm64
chown root:root cfssl_1.6.4_linux_arm64
chown root:root cfssljson_1.6.4_linux_arm64

chmod +x cfssl-certinfo_1.6.4_linux_arm64
chmod +x cfssl_1.6.4_linux_arm64
chmod +x cfssljson_1.6.4_linux_arm64

cp -a cfssl-certinfo_1.6.4_linux_arm64 ../artifact/cfssl/cfssl-certinfo
cp -a cfssl_1.6.4_linux_arm64          ../artifact/cfssl/cfssl
cp -a cfssljson_1.6.4_linux_arm64      ../artifact/cfssl/cfssljson

cp -a cfssl-certinfo_1.6.4_linux_arm64 /usr/local/bin/cfssl-certinfo
cp -a cfssl_1.6.4_linux_arm64          /usr/local/bin/cfssl
cp -a cfssljson_1.6.4_linux_arm64      /usr/local/bin/cfssljson

date
