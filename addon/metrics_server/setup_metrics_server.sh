#!/bin/bash

set -e
set -o pipefail
set -u
set -x

cd "$(dirname "$0")"

date

kubectl describe node |grep -E "^Name:|^Roles:|^Taints:"

# kubectl taint node "$(hostname |tr '[:uppper:]' '[:lower:]')" node-role.kubernetes.io/master=:NoSchedule --overwrite
kubectl taint node "$(hostname |tr '[:uppper:]' '[:lower:]')" node-role.kubernetes.io/control-plane=:NoSchedule --overwrite

kubectl describe node |grep -E "^Name:|^Roles:|^Taints:"

date
