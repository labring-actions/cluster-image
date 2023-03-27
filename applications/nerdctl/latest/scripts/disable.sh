#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

app_name="nerdctl"

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

sealos exec "
if command -v nerdctl > /dev/null 2>&1;then
  systemctl disable --now buildkit.socket >/dev/null 2>&1 || true
  systemctl disable --now buildkit.service >/dev/null 2>&1 || true
  rm -rf /etc/systemd/system/buildkit.service
  rm -rf /etc/systemd/system/buildkit.socket
  rm -rf /etc/buildkit/buildkitd.toml
  rm -rf /usr/local/bin/buildctl
  rm -rf /usr/local/bin/buildkitd
  rm -rf /usr/local/bin/buildkit-qemu-aarch64
  rm -rf /usr/local/bin/buildkit-qemu-arm
  rm -rf /usr/local/bin/buildkit-qemu-i386
  rm -rf /usr/local/bin/buildkit-qemu-mips64
  rm -rf /usr/local/bin/buildkit-qemu-mips64el
  rm -rf /usr/local/bin/buildkit-qemu-ppc64le
  rm -rf /usr/local/bin/buildkit-qemu-riscv64
  rm -rf /usr/local/bin/buildkit-qemu-s390x
  rm -rf /usr/local/bin/buildkit-runc
  rm -rf /usr/local/bin/nerdctl
fi
"
log::info "${app_name} is uninstalled"
