#!/bin/bash

set -eu

readonly ARCH=${arch?}
readonly CRI_TYPE=${criType?}
readonly KUBE=${kubeVersion?}

readonly DOCKER=$(
  echo 20.10.18 ||
  until wget -qO- https://api.github.com/repos/moby/moby/tags; do sleep 3; done |
    yq '.[].name' | grep -E "^v[0-9\.]+[0-9]$" |
    head -n 1 | cut -dv -f2
)
readonly CRIDOCKER=$(
  until wget -qO- https://api.github.com/repos/Mirantis/cri-dockerd/tags; do sleep 3; done |
    yq '.[].name' | grep -E "^v[0-9\.]+[0-9]$" |
    head -n 1 | cut -dv -f2
)
readonly CONTAINERD=$(
  echo 1.6.2 ||
  until wget -qO- https://api.github.com/repos/containerd/containerd/tags; do sleep 3; done |
    yq '.[].name' | grep -E "^v[0-9\.]+[0-9]$" |
    head -n 1 | cut -dv -f2
)
readonly CRICTL=$(
  until wget -qO- https://api.github.com/repos/kubernetes-sigs/cri-tools/tags; do sleep 3; done |
    yq '.[].name' | grep "^v${KUBE%.*}." |
    head -n 1
)

readonly ROOT="/tmp/$(whoami)/download/$ARCH"
mkdir -p "$ROOT"

cd "$ROOT" && {
  until wget -qO "crictl.tar.gz" "https://github.com/kubernetes-sigs/cri-tools/releases/download/$CRICTL/crictl-$CRICTL-linux-$ARCH.tar.gz"; do sleep 3; done
  case $CRI_TYPE in
  containerd)
    until wget -qO "dl.tgz" "https://github.com/containerd/containerd/releases/download/v$CONTAINERD/cri-containerd-cni-$CONTAINERD-linux-$ARCH.tar.gz"; do sleep 3; done
    {
      mkdir -p usr/bin
      tar -zxf dl.tgz -C usr/bin --strip-components=3 usr/local/bin
      tar -zxf dl.tgz -C usr/bin --strip-components=3 usr/local/sbin
      rm -f dl.tgz usr/bin/critest
      tar -zxf crictl.tar.gz -C usr/bin
      tar -zcf "cri-containerd.tar.gz" usr
      rm -rf usr
    }
    ;;
  docker)
    case $KUBE in
    1.*.*)
      until wget -qO "cri-dockerd.tgz" "https://github.com/Mirantis/cri-dockerd/releases/download/v$CRIDOCKER/cri-dockerd-$CRIDOCKER.$ARCH.tgz"; do sleep 3; done
      case $ARCH in
      amd64)
        DOCKER_ARCH=x86_64
        ;;
      arm64)
        DOCKER_ARCH=aarch64
        ;;
      *)
        echo "Unsupported architecture $ARCH"
        exit
        ;;
      esac
      until wget -qO "docker.tgz" "https://download.docker.com/linux/static/stable/$DOCKER_ARCH/docker-$DOCKER.tgz"; do sleep 3; done
      ;;
    esac
    ;;
  esac
  until wget -qO "library.tar.gz" "https://github.com/labring/cluster-image/releases/download/depend/library-2.5-linux-$ARCH.tar.gz"; do sleep 3; done
  {
    REGISTRY=$(curl --silent "https://api.github.com/repos/distribution/distribution/releases/latest" | grep tarball_url | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' | cut -dv -f2)
    until wget -qO- "https://github.com/distribution/distribution/releases/download/v$REGISTRY/registry_${REGISTRY}_linux_$ARCH.tar.gz"; do sleep 3; done |
      tar -zx registry
  }
  until wget -qO "lsof" "https://github.com/labring/cluster-image/releases/download/depend/lsof-linux-$ARCH"; do sleep 3; done
}

echo "$0"
tree "$ROOT"
