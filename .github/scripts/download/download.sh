#!/bin/bash

set -ex

readonly ARCH=amd64
readonly SEALOS=${sealoslatest:-$(
  until curl -sL "https://api.github.com/repos/labring/sealos/releases/latest"; do sleep 3; done | grep tarball_url | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' | cut -dv -f2
)}

readonly ROOT="/tmp/$(whoami)/bin"
mkdir -p "$ROOT"

sudo apt remove buildah -y || true
until curl -sLo buildah "https://github.com/labring-actions/cluster-image/releases/download/depend/buildah.linux.amd64"; do sleep 3; done && {
  chmod a+x buildah
  sudo cp -auv buildah /usr/bin/
}

sudo buildah from --name "tools-$ARCH" "ghcr.io/labring-actions/cache:tools-$ARCH"
readonly MOUNT_TOOLS=$(sudo buildah mount "tools-$ARCH")

cd "$ROOT" && {
    sudo cp -a $MOUNT_TOOLS/* .
    if [[ -n "$sealosPatch" ]]; then
      sudo buildah from --name "sealos-$ARCH" ghcr.io/labring/sealos:dev
      sudo cp -a "$(sudo buildah mount "$SEALOS")" /usr/bin/sealos .
    else
      sudo buildah from --name "sealos-$ARCH" "ghcr.io/labring-actions/cache:sealos-v$SEALOS-$ARCH"
      sudo cp -a "$(sudo buildah mount "$SEALOS")" /v$SEALOS/sealos .
    fi
}

sudo buildah umount "tools-$ARCH"
sudo buildah umount "sealos-$ARCH"

echo "$0"
tree "$ROOT"

{
  chmod a+x "$ROOT"/*
  sudo cp -auv "$ROOT"/* /usr/bin
  sudo sealos version
}
