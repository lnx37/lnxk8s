#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p pkg

cd pkg

# https://github.com/cloudflare/cfssl
# https://github.com/cloudflare/cfssl/releases
#
# wget -c "https://github.com/cloudflare/cfssl/releases/download/1.2.0/cfssl-certinfo_linux-amd64" -O cfssl-certinfo_linux-amd64
# wget -c "https://github.com/cloudflare/cfssl/releases/download/1.2.0/cfssl_linux-amd64"          -O cfssl_linux-amd64
# wget -c "https://github.com/cloudflare/cfssl/releases/download/1.2.0/cfssljson_linux-amd64"      -O cfssljson_linux-amd64
# wget -c "https://github.com/cloudflare/cfssl/releases/download/v1.6.4/cfssl-certinfo_1.6.4_linux_amd64" -O cfssl-certinfo_1.6.4_linux_amd64
# wget -c "https://github.com/cloudflare/cfssl/releases/download/v1.6.4/cfssl_1.6.4_linux_amd64"          -O cfssl_1.6.4_linux_amd64
# wget -c "https://github.com/cloudflare/cfssl/releases/download/v1.6.4/cfssljson_1.6.4_linux_amd64"      -O cfssljson_1.6.4_linux_amd64
#
# wget -c "http://199.115.230.237:12345/kubernetes/cfssl-certinfo_linux-amd64" -O cfssl-certinfo_linux-amd64
# wget -c "http://199.115.230.237:12345/kubernetes/cfssl_linux-amd64"          -O cfssl_linux-amd64
# wget -c "http://199.115.230.237:12345/kubernetes/cfssljson_linux-amd64"      -O cfssljson_linux-amd64
# wget -c "http://199.115.230.237:12345/kubernetes/cfssl-certinfo_1.6.4_linux_amd64" -O cfssl-certinfo_1.6.4_linux_amd64
# wget -c "http://199.115.230.237:12345/kubernetes/cfssl_1.6.4_linux_amd64"          -O cfssl_1.6.4_linux_amd64
# wget -c "http://199.115.230.237:12345/kubernetes/cfssljson_1.6.4_linux_amd64"      -O cfssljson_1.6.4_linux_amd64
wget -c "http://199.115.230.237:12345/kubernetes/cfssl-certinfo_1.6.4_linux_amd64" -O cfssl-certinfo_1.6.4_linux_amd64
wget -c "http://199.115.230.237:12345/kubernetes/cfssl_1.6.4_linux_amd64"          -O cfssl_1.6.4_linux_amd64
wget -c "http://199.115.230.237:12345/kubernetes/cfssljson_1.6.4_linux_amd64"      -O cfssljson_1.6.4_linux_amd64

date
