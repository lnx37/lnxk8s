#!/bin/bash

set -e
set -o pipefail
set -u
# set -x

# cd "$(dirname "$0")"

date

# // info
# https://www.shellcheck.net/wiki/SC1091
# source env.sh
#        ^----^ SC1091 (info): Not following: env.sh was not specified as input (see shellcheck -x).
#
# // style
# https://www.shellcheck.net/wiki/SC2001
# HOSTS="$(echo "$HOSTS" |sed "s/^,//g")"
#          ^--------------------------^ SC2001 (style): See if you can use ${variable//search/replace} instead.
#
# // style
# https://www.shellcheck.net/wiki/SC2002
# if [ "$(cat /proc/swaps |grep -v "^Filename" |wc -l)" -ne 0 ]; then
#             ^---------^ SC2002 (style): Useless cat. Consider 'cmd < file | ..' or 'cmd file | ..' instead.
#
# // info
# https://www.shellcheck.net/wiki/SC2009
# ps -ef |grep "nginx"
# ^----^ SC2009 (info): Consider using pgrep instead of grepping ps output.
#
# // info
# https://www.shellcheck.net/wiki/SC2029
# ssh root@"${ETCD_IP}" "bash /opt/artifact/install_etcd_${ETCD_NAME}.sh"
#                                                        ^----------^ SC2029 (info): Note that, unescaped, this expands on the client side.
#
# // warning
# https://www.shellcheck.net/wiki/SC2034
# WORKER_IP_LIST=("172.22.26.31" "172.22.26.32")
# ^------------^ SC2034 (warning): WORKER_IP_LIST appears unused. Verify use (or export if used externally).
#
# // style
# https://www.shellcheck.net/wiki/SC2126
# if [ "$(cat /proc/swaps |grep -v "^Filename" |wc -l)" -ne 0 ]; then
#                          ^-----------------^ SC2126 (style): Consider using 'grep -c' instead of 'grep|wc -l'.
#
# https://www.shellcheck.net/wiki/SC1091
# https://www.shellcheck.net/wiki/SC2001
# https://www.shellcheck.net/wiki/SC2002
# https://www.shellcheck.net/wiki/SC2009
# https://www.shellcheck.net/wiki/SC2029
# https://www.shellcheck.net/wiki/SC2034
# https://www.shellcheck.net/wiki/SC2126
#
# SC2034: # shellcheck disable=SC2034

{
find . -name "*.sh" \
  -not \( -name ".git" -prune \) \
  -not \( -path "./addon/coredns/yml/deploy.sh" -prune \)
} |while read -r file; do
  echo "$file"

  shellcheck \
    --exclude=SC1091 \
    --exclude=SC2001 \
    --exclude=SC2002 \
    --exclude=SC2009 \
    --exclude=SC2029 \
    --exclude=SC2126 \
    "$file"
done

date
