#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

mkdir -p artifact/kubernetes

cd artifact/kubernetes

# -- template
# cfssl print-defaults config
# cfssl print-defaults csr
#
# -- kubeadm
# cfssl-certinfo --cert /etc/kubernetes/pki/ca.crt
#
# -- refer
# https://kubernetes.io/docs/setup/best-practices/certificates/
# https://kubernetes.io/docs/tasks/administer-cluster/certificates/
# https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/04-certificate-authority.md
cat <<EOF >ca-config.json
{
  "signing": {
    "default": {
      "expiry": "876000h"
    },
    "profiles": {
      "kubernetes": {
        "expiry": "876000h",
        "usages": [
          "signing",
          "key encipherment",
          "server auth",
          "client auth"
        ]
      }
    }
  }
}
EOF
cat <<EOF >ca-csr.json
{
  "CN": "kubernetes-ca",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CHANGEME",
      "ST": "CHANGEME",
      "L": "CHANGEME",
      "O": "kubernetes",
      "OU": "CHANGEME"
    }
  ]
}
EOF

# -- input
# ca-csr.json
#
# -- output
# ca-key.pem
# ca.csr
# ca.pem
cfssl gencert -initca ca-csr.json |cfssljson -bare ca

# ---

# -- kubeadm
# cfssl-certinfo --cert /etc/kubernetes/pki/front-proxy-ca.crt
cat <<EOF >front-proxy-ca-config.json
{
  "signing": {
    "default": {
      "expiry": "876000h"
    },
    "profiles": {
      "kubernetes": {
        "expiry": "876000h",
        "usages": [
          "signing",
          "key encipherment",
          "server auth",
          "client auth"
        ]
      }
    }
  }
}
EOF
cat <<EOF >front-proxy-ca-csr.json
{
  "CN": "front-proxy-ca",
  "key": {
     "algo": "rsa",
     "size": 2048
  }
}
EOF

# -- input
# front-proxy-ca-csr.json
#
# -- output
# front-proxy-ca-key.pem
# front-proxy-ca.csr
# front-proxy-ca.pem
cfssl gencert -initca front-proxy-ca-csr.json |cfssljson -bare front-proxy-ca

# -- kubeadm
# cfssl-certinfo --cert /etc/kubernetes/pki/front-proxy-client.crt
cat <<EOF >front-proxy-client-csr.json
{
  "CN": "front-proxy-client",
  "key": {
     "algo": "rsa",
     "size": 2048
  }
}
EOF

# -- input
# front-proxy-ca.pem
# front-proxy-ca-key.pem
# front-proxy-ca-config.json
# front-proxy-client-csr.json
#
# -- output
# front-proxy-client-key.pem
# front-proxy-client.csr
# front-proxy-client.pem
cfssl gencert \
  -ca=front-proxy-ca.pem \
  -ca-key=front-proxy-ca-key.pem \
  -config=front-proxy-ca-config.json \
  -profile=kubernetes \
  front-proxy-client-csr.json |cfssljson -bare front-proxy-client

# ---

# -- output
# sa.key
# sa.pub
openssl genrsa -out sa.key 2048
openssl rsa -in sa.key -pubout -out sa.pub

date
