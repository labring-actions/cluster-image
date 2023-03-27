#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

app_name="nerdctl"
log::info "installing ${app_name}"
sealos exec "systemctl stop buildkit.socket >/dev/null 2>&1 || true"
sealos exec "mkdir -p /etc/buildkit"
sealos scp ../etc/buildkit.service /etc/systemd/system/buildkit.service
sealos scp ../etc/buildkit.socket /etc/systemd/system/buildkit.socket
sealos scp ../etc/buildkitd.toml /etc/buildkit/buildkitd.toml
sealos scp ../opt /usr/local/bin
sealos exec "systemctl enable --now buildkit"
log::info "${app_name} is installed"
