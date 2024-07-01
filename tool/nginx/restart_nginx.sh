#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

bash stop_nginx.sh

bash start_nginx.sh

bash status_nginx.sh

date
