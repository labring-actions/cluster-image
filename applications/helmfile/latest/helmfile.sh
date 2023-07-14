#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

[[ -n $DEBUG ]] && set -x

NAME=${NAME:-"helmfile"}

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function install(){
  sealos scp -r master ./opt/helmfile /usr/bin/helmfile
  sealos exec -r master "mkdir -p /root/.local/share/helm/plugins/helm-diff"
  sealos scp -r master ./opt/diff /root/.local/share/helm/plugins/helm-diff
}

function uninstall(){
  sealos exec -r master "
  binary=/usr/local/bin/helmfile
  rm -rf /root/.local/share/helm/plugins/helm-diff
  rm -rf /usr/bin/helmfile
  "
  log::info "${NAME} has been removed"
}

if [ -z ${uninstall} ]; then
  install
elif [ -n ${uninstall} ]; then
  uninstall
fi
