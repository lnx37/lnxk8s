#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

wget -c "https://nginx.org/download/nginx-1.24.0.tar.gz" -O nginx-1.24.0.tar.gz

date
