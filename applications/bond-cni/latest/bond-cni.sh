#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function install() {
  sealos exec "mkdir -p /opt/cni/bin/"
  sealos scp opt/bond /opt/cni/bin/bond
  sealos exec "chmod +x /opt/cni/bin/bond"
}

function uninstall() {
  log::info "uninstall bond-cni"
  if [ -f /opt/cni/bin/bond ]; then
    rm -rf /opt/cni/bin/bond
  fi
}

if [ -z ${uninstall} ]; then
  install
elif [ -n ${uninstall} ]; then
  uninstall
fi
