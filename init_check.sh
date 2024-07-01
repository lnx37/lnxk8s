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

# selinux
for IP in "${UNIQUE_IP_LIST[@]}"; do
  if (ssh root@"$IP" "which getenforce >/dev/null 2>&1"); then
    result="$(ssh root@"$IP" "getenforce" 2>/dev/null)"
    [ "$result" != "Disabled" ] && echo "it seems selinux enabled"
  fi
done

# firewalld
for IP in "${UNIQUE_IP_LIST[@]}"; do
  if (root@"$IP" "systemctl status firewalld >/dev/null 2>&1"); then
    echo "it seems firewalld started"
  fi
done

# swap
for IP in "${UNIQUE_IP_LIST[@]}"; do
  result="$(ssh root@"$IP" "cat /proc/swaps |grep -v '^Filename' |wc -l" 2>/dev/null)"
  [ "$result" -ne 0 ] && echo "it seems swap is on"
  result="$(ssh root@"$IP" "cat /etc/fstab |grep 'swap' |grep -v '^#' |wc -l" 2>/dev/null)"
  [ "$result" -ne 0 ] && echo "it seems swap is on"
done

date
