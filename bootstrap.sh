#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source env.sh
echo "${DRY_RUN}"
echo "${SKIP_DOWNLOAD}"

started_at=$(date +%s)

# [ -d pkg ] && rm -rf pkg
[ -d artifact ] && rm -rf artifact

if [ "${DRY_RUN}" == "yes" ]; then
  [ "${SKIP_DOWNLOAD}" == "no" ] && bash download.sh
  bash unpkg.sh
  bash make.sh
  bash stage.sh
fi

if [ "${DRY_RUN}" == "no" ]; then
  bash init.sh
  [ "${SKIP_DOWNLOAD}" == "no" ] && bash download.sh
  bash unpkg.sh
  bash make.sh
  bash stage.sh
  bash distribute.sh
  bash install.sh
  bash setup.sh
fi

ended_at=$(date +%s)

time_elapsed=$((ended_at - started_at))
echo "time elapsed: ${time_elapsed} secs"

date
