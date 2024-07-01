#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

rm -f /usr/local/bin/istioctl

date
