#!/bin/bash

set -eu

readonly ARCH=${arch?}
readonly CRI_TYPE=${criType?}
readonly KUBE=${kubeVersion?}

readonly REGISTRY=$(
  until curl -sL https://api.github.com/repos/distribution/distribution/tags; do sleep 3; done |
    yq '.[].name' | grep -E "^v[0-9\.]+[0-9]$" |
    head -n 1 | cut -dv -f2
)
readonly DOCKER=$(
  until curl -sL https://api.github.com/repos/moby/moby/tags; do sleep 3; done |
    yq '.[].name' | grep -E "^v[0-9\.]+[0-9]$" |
    head -n 1 | cut -dv -f2
)
readonly CRIDOCKER=$(
  until curl -sL https://api.github.com/repos/Mirantis/cri-dockerd/tags; do sleep 3; done |
    yq '.[].name' | grep -E "^v[0-9\.]+[0-9]$" |
    head -n 1 | cut -dv -f2
)
readonly CONTAINERD=$(
  echo 1.6.2 ||
  until curl -sL https://api.github.com/repos/containerd/containerd/tags; do sleep 3; done |
    yq '.[].name' | grep -E "^v[0-9\.]+[0-9]$" |
    head -n 1 | cut -dv -f2
)
readonly CRICTL=$(
  until curl -sL https://api.github.com/repos/kubernetes-sigs/cri-tools/tags; do sleep 3; done |
    yq '.[].name' | grep -E "^v[0-9\.]+[0-9]$" >$HOSTNAME.tags
    grep "^v${KUBE%.*}." $HOSTNAME.tags || head -n 1 $HOSTNAME.tags
)

readonly CRIO=$(
  until curl -sL https://api.github.com/repos/cri-o/cri-o/tags; do sleep 3; done |
    yq '.[].name' | grep -E "^v[0-9\.]+[0-9]$" >$HOSTNAME.tags
    grep "^v${KUBE%.*}." $HOSTNAME.tags || head -n 1 $HOSTNAME.tags
)

readonly ROOT="/tmp/$(whoami)/download/$ARCH"
mkdir -p "$ROOT"

cd "$ROOT" && {
  until curl -sLo "crictl.tar.gz" "https://github.com/kubernetes-sigs/cri-tools/releases/download/$CRICTL/crictl-$CRICTL-linux-$ARCH.tar.gz"; do sleep 3; done
  case $CRI_TYPE in
  containerd)
    until curl -sLo "dl.tgz" "https://github.com/containerd/containerd/releases/download/v$CONTAINERD/cri-containerd-cni-$CONTAINERD-linux-$ARCH.tar.gz"; do sleep 3; done
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
  cri-o)
    until curl -sLo "cri-o.tar.gz" "https://github.com/cri-o/cri-o/releases/download/$CRIO/cri-o.$ARCH.$CRIO.tar.gz"; do sleep 3; done
    {
      echo "download finished!"
    }
    ;;
  docker)
    case $KUBE in
    1.*.*)
      until curl -sLo "cri-dockerd.tgz" "https://github.com/Mirantis/cri-dockerd/releases/download/v$CRIDOCKER/cri-dockerd-$CRIDOCKER.$ARCH.tgz"; do sleep 3; done
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
      until curl -sLo "docker.tgz" "https://download.docker.com/linux/static/stable/$DOCKER_ARCH/docker-$DOCKER.tgz"; do sleep 3; done
      ;;
    esac
    ;;
  esac
  until curl -sLo "library.tar.gz" "https://github.com/labring/cluster-image/releases/download/depend/library-2.5-linux-$ARCH.tar.gz"; do sleep 3; done
  {
    until curl -sL "https://github.com/distribution/distribution/releases/download/v$REGISTRY/registry_${REGISTRY}_linux_$ARCH.tar.gz"; do sleep 3; done |
      tar -zx registry
  }
  until curl -sLo "lsof" "https://github.com/labring/cluster-image/releases/download/depend/lsof-linux-$ARCH"; do sleep 3; done
}

echo "$0"
tree "$ROOT"

