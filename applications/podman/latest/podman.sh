#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

[[ -n $DEBUG ]] && set -x

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

function install(){
  sealos exec "mkdir -p /tmp/podman-linux"
  sealos scp ./opt/podman-linux /tmp/podman-linux
  sealos exec "cp -rn /tmp/podman-linux/usr /tmp/podman-linux/etc /"
  sealos exec "rm -rf /tmp/podman-linux"
}

function uninstall(){
  log::info "uninstall podman"
  sealos exec "
  rm -rf etc/cni/net.d/87-podman-bridge.conflist
  [ -f /usr/local/bin/fuse-overlayfs ] && mv -f /usr/local/bin/fuse-overlayfs{,_bak_podman}
  [ -f /usr/local/bin/fusermount3 ] && mv -f /usr/local/bin/fusermount3{,_bak_podman}
  rm -rf /usr/local/bin/podman
  [ -f /usr/local/bin/runc ] && mv -f /usr/local/bin/runc{,.bak}
  [ -f /usr/local/bin/slirp4netns ] && mv -f /usr/local/bin/slirp4netns{,_bak_podman}
  [ -f /usr/local/lib/cni/bridge ] && mv -f /usr/local/lib/cni/bridge{,_bak_podman}
  [ -f /usr/local/lib/cni/firewall ] && mv -f /usr/local/lib/cni/firewall{,_bak_podman}
  [ -f /usr/local/lib/cni/host-local ] && mv -f /usr/local/lib/cni/host-local{,_bak_podman}
  [ -f /usr/local/lib/cni/loopback ] && mv -f /usr/local/lib/cni/loopback{,_bak_podman}
  [ -f /usr/local/lib/cni/portmap ] && mv -f /usr/local/lib/cni/portmap{,_bak_podman}
  [ -f /usr/local/lib/cni/tuning ] && mv -f /usr/local/lib/cni/tuning{,_bak_podman}
  rm -rf /usr/local/lib/podman
  "
}

if [ -z ${uninstall} ]; then
  install
elif [ -n ${uninstall} ]; then
  uninstall
fi
