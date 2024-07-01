#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

if [ -d /opt/nginx-1.24.0 ]; then
  echo "/opt/nginx-1.24.0 already exists"
  exit 0
fi

[ -d nginx-1.24.0 ] && rm -rf nginx-1.24.0
tar xzf nginx-1.24.0.tar.gz

cd nginx-1.24.0
./configure \
  --prefix=/opt/nginx-1.24.0 \
  --with-stream \
  --without-http_gzip_module \
  --without-http_rewrite_module
make
make install

/opt/nginx-1.24.0/sbin/nginx -V

date
