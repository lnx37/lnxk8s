#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

if (ps -ef |grep "nginx.*process" |grep -v "grep"); then
  ps -ef |grep "nginx.*process" |grep -v "grep" |awk '{print $2}' |xargs kill -9
fi

date
