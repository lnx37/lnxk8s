#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

nerdctl namespace ls

nerdctl ps
nerdctl images

nerdctl -n k8s.io ps
nerdctl -n k8s.io images

date
