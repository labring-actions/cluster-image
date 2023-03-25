#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME="flannel"
NAMESPACE="kube-flannel"

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

if helm -n ${NAMESPACE} status ${NAME}; then
  helm -n ${NAMESPACE} uninstall ${NAME} > /dev/null 2>&1
fi

sealos exec "
if ip link show flannel.1
then
  echo 'Deleting old flannel.1 link'
  ip link delete flannel.1
fi

if ip link show cni0
then
  echo 'Deleting old cni0 link'
  ip link delete cni0
fi

rm -rf /var/lib/cni/
rm -f /etc/cni/net.d/*
systemctl restart kubelet
"
log::info "${NAME} is uninstalled"
