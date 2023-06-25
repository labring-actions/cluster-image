#!/bin/bash

set -e

readonly ARCH=amd64
readonly SEALOS=${sealoslatest:-$(
  until curl -sL "https://api.github.com/repos/labring/sealos/releases/latest" | grep tarball_url; do sleep 3; done | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' | cut -dv -f2
)}
readonly IMAGE_CACHE_NAME="ghcr.io/labring-actions/cache"
readonly ROOT="/tmp/$(whoami)/bin"
mkdir -p "$ROOT"

until sudo podman run --rm -v "/usr/bin:/pwd" -w /tools --entrypoint /bin/sh "$IMAGE_CACHE_NAME:tools-amd64" -c "cp -a buildah /pwd"; do
  sleep 1
done

cd "$ROOT" && {
  podman run --rm -v "$PWD:/pwd" -w /tools --entrypoint /bin/sh "$IMAGE_CACHE_NAME:tools-$ARCH" -c "cp -a . /pwd"
  if [[ -n "$sealosPatch" ]]; then
    podman run --rm -v "$PWD:/pwd" -w /usr/bin --entrypoint /bin/sh ghcr.io/labring/sealos:dev -c "cp -a sealos /pwd"
  else
    podman run --rm -v "$PWD:/pwd" -w /sealos --entrypoint /bin/sh "$IMAGE_CACHE_NAME:sealos-v$SEALOS-$ARCH" -c "cp -a sealos /pwd"
  fi
  sudo chown "$(whoami)" ./*
}

echo "$0"
tree "$ROOT" || true

{
  chmod a+x "$ROOT"/*
  sudo cp -auv "$ROOT"/* /usr/bin
  sudo sealos version
}
