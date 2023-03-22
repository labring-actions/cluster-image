#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

app_name="helmfile"
log::info "installing ${app_name}"
sealos scp -r master ../opt/helm /usr/bin/helm
sealos scp -r master ../opt/helmfile /usr/bin/helmfile
sealos exec -r master "mkdir -p /root/.local/share/helm/plugins/helm-diff"
sealos scp -r master ../opt/diff /root/.local/share/helm/plugins/helm-diff
log::info "${app_name} is installed"
