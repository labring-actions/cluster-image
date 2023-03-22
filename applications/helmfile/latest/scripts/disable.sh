#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

app_name="helmfile"
log::info "uninstalling ${app_name}"
sealos exec -r master "
rm -rf /root/.local/share/helm/plugins/helm-diff
rm -rf /usr/bin/helm
rm -rf /usr/bin/helmfile
"
log::info "${app_name} is uninstalled"
