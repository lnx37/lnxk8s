#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

source env.sh
echo "${ETCD_IP_LIST[@]}"
echo "${MASTER_IP_LIST[@]}"
echo "${WORKER_IP_LIST[@]}"

UNIQUE_IP_LIST=()
IP_LIST=("${ETCD_IP_LIST[@]}" "${MASTER_IP_LIST[@]}" "${WORKER_IP_LIST[@]}")
UNIQUE_IP_STR="$(for IP in "${IP_LIST[@]}"; do echo "$IP"; done |sort -u)"
while read -r line; do UNIQUE_IP_LIST+=("$line"); done < <(echo "${UNIQUE_IP_STR}")
echo "${IP_LIST[@]}"
echo "${UNIQUE_IP_STR}"
echo "${UNIQUE_IP_LIST[@]}"

for IP in "${UNIQUE_IP_LIST[@]}"; do
  grep "^$IP " ~/.ssh/known_hosts >/dev/null 2>&1 || ssh-keyscan "$IP" >>~/.ssh/known_hosts
  timeout 5 ssh root@"$IP" "hostname"
done

date
