#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

/opt/nginx-1.24.0/sbin/nginx

date
