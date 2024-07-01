#!/bin/bash

set -e
set -o pipefail
set -u
set -x

date

cd "$(dirname "$0")"

bash download_nginx.sh

bash install_nginx.sh

bash setup_nginx.sh

bash start_nginx.sh

bash status_nginx.sh

date
