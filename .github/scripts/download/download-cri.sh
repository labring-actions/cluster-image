#!/bin/bash

set -eu

readonly ARCH=${arch?}
readonly CRI_TYPE=${criType?}
readonly KUBE=${kubeVersion?}

readonly DOCKER=${dockerVersion:-$(date +%F)}
readonly CRIDOCKER=${criDockerVersion:-$(date +%F)}
readonly CONTAINERD=${containerdVersion:-$(date +%F)}
readonly NERDCTL=${nerdctlVersion:-$(date +%F)}
readonly CRICTL=$(
  curl --silent https://api.github.com/repos/kubernetes-sigs/cri-tools/tags |
    yq '.[].name' | grep "^v${KUBE%.*}." |
    head -n 1
)

readonly ROOT="/tmp/$(whoami)/download/$ARCH"
mkdir -p "$ROOT"

cd "$ROOT" && {
  wget -qO "crictl.tar.gz" "https://github.com/kubernetes-sigs/cri-tools/releases/download/$CRICTL/crictl-$CRICTL-linux-$ARCH.tar.gz"
  case $CRI_TYPE in
  containerd)
    wget -qO "dl.tgz" "https://github.com/containerd/containerd/releases/download/v$CONTAINERD/cri-containerd-cni-$CONTAINERD-linux-$ARCH.tar.gz"
    {
      mkdir -p usr/bin
      tar -zxf dl.tgz -C usr/bin --strip-components=3 usr/local/bin
      tar -zxf dl.tgz -C usr/bin --strip-components=3 usr/local/sbin
      rm -f dl.tgz usr/bin/critest
      tar -zxf crictl.tar.gz -C usr/bin
      tar -zcf "cri-containerd.tar.gz" usr
      rm -rf usr
    }
    wget -qO- "https://github.com/containerd/nerdctl/releases/download/v$NERDCTL/nerdctl-$NERDCTL-linux-$ARCH.tar.gz" |
      tar -zx nerdctl
    ;;
  docker)
    case $KUBE in
    1.*.*)
      wget -qO "cri-dockerd.tgz" "https://github.com/Mirantis/cri-dockerd/releases/download/v$CRIDOCKER/cri-dockerd-$CRIDOCKER.$ARCH.tgz"
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
      wget -qO "docker.tgz" "https://download.docker.com/linux/static/stable/$DOCKER_ARCH/docker-$DOCKER.tgz"
      ;;
    esac
    ;;
  esac
  wget -qO "library.tar.gz" "https://github.com/labring/cluster-image/releases/download/depend/library-2.5-linux-$ARCH.tar.gz"
  wget -qO "registry.tar" "https://github.com/labring/cluster-image/releases/download/depend/registry-$ARCH.tar"
  {
    REGISTRY=$(curl --silent "https://api.github.com/repos/distribution/distribution/releases/latest" | grep tarball_url | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' | cut -dv -f2)
    wget -qO- "https://github.com/distribution/distribution/releases/download/v$REGISTRY/registry_${REGISTRY}_linux_$ARCH.tar.gz" |
      tar -zx registry
  }
  wget -qO "lsof" "https://github.com/labring/cluster-image/releases/download/depend/lsof-linux-$ARCH"
}

echo "$0"
tree "$ROOT"
