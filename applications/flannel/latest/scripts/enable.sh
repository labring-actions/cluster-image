#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME="flannel"
NAMESAPCE="kube-flannel"

HELM_OPTS=
if [ -n "${POD_CIDR}" ]; then
  HELM_OPTS+="--set podCidr=${POD_CIDR} "
fi
if [ -n "${BACKEND}" ]; then
  HELM_OPTS+="--set flannel.backend=${BACKEND} "
fi

kubectl create ns ${NAMESAPCE} > /dev/null 2>&1 || true
kubectl label --overwrite ns ${NAMESAPCE} pod-security.kubernetes.io/enforce=privileged
helm upgrade -i flannel ../charts/flannel -n ${NAMESAPCE} ${HELM_OPTS}
