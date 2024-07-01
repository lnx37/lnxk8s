#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

bash init_ssh.sh

bash init_check.sh

date
