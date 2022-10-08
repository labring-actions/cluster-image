#!/bin/bash

set -e

readonly HELM=${helmVersion:-$(
  until wget -qO- "https://api.github.com/repos/helm/helm/releases/latest"; do sleep 3; done | grep tarball_url | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' | cut -dv -f2
)}
readonly SEALOS=${sealoslatest:-$(
  until wget -qO- "https://api.github.com/repos/labring/sealos/releases/latest"; do sleep 3; done | grep tarball_url | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' | cut -dv -f2
)}

readonly YQ=${yqVersion:-$(
  until wget -qO- "https://api.github.com/repos/mikefarah/yq/releases/latest"; do sleep 3; done | grep tarball_url | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' | cut -dv -f2
)}

readonly ROOT="/tmp/$(whoami)/bin"
mkdir -p "$ROOT"

sudo apt remove buildah -y || true

cd "$ROOT" && {
  until wget -qO- "https://get.helm.sh/helm-v$HELM-linux-amd64.tar.gz"; do sleep 3; done |
    tar -zx linux-amd64/helm --strip-components=1
  until wget -qO "buildah" "https://github.com/labring/cluster-image/releases/download/depend/buildah.linux.amd64"; do sleep 3; done
  if [[ -n "$sealosPatch" ]]; then
    chmod a+x "buildah"
    sudo cp -a "buildah" /usr/bin
    sudo buildah from --name "$SEALOS" "ghcr.io/labring/sealos:dev"
    sudo cp -a "$(sudo buildah mount "$SEALOS")"/usr/bin/sealos .
    sudo chown -R "$USER:$USER" .
    sudo buildah umount "$SEALOS"
  else
    until wget -qO- "https://github.com/labring/sealos/releases/download/v$SEALOS/sealos_${SEALOS}_linux_amd64.tar.gz"; do sleep 3; done |
      tar -zx sealos
  fi
  until wget -qO "yq" "https://github.com/mikefarah/yq/releases/download/v$YQ/yq_linux_amd64"; do sleep 3; done
}

echo "$0"
tree "$ROOT"

{
  chmod a+x "$ROOT"/*
  sudo cp -auv "$ROOT"/* /usr/bin
  sudo sealos version
}
