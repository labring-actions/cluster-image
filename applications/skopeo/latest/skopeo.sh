#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

[[ -n $DEBUG ]] && set -x

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function install(){
  sealos scp ./opt/skopeo /usr/bin/skopeo
  sealos exec "chmod +x /usr/bin/skopeo"
}

function uninstall(){
  log::info "uninstall ${NAME}"
  sealos exec "rm -rf /usr/bin/skopeo"
}

if [ -z ${uninstall} ]; then
  install
elif [ -n ${uninstall} ]; then
  uninstall
fi
