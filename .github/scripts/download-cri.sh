#!/bin/bash

set -e

ARCH=${arch?}
CRI_TYPE=${criType?}

DOCKER=${dockerVersion}
CRIDOCKER=${criDockerVersion}
CONTAINERD=${containerdVersion}
NERDCTL=${nerdctlVersion}

case $CRI_TYPE in
containerd)
  mkdir -p ".download/containerd/$ARCH" && {
    if wget -qO dl.tgz "https://github.com/containerd/containerd/releases/download/v$CRIDOCKER/cri-containerd-cni-$CRIDOCKER-linux-$ARCH.tar.gz"; then
      mkdir -p usr/bin
      tar -zxf dl.tgz usr/local/bin -C usr/bin --strip-components=3
      tar -zxf dl.tgz usr/local/sbin -C usr/bin --strip-components=3
      rm -rf usr/bin/critest
      tar -zcf ".download/containerd/$ARCH/cri-containerd-cni-linux.tar.gz" usr
      rm dl.tgz
    else
      echo "====download and targz containerd failed!===="
    fi
  }
  mkdir -p ".download/nerdctl/$ARCH" && {
    if wget -qO- "https://github.com/containerd/nerdctl/releases/download/v$NERDCTL/nerdctl-$NERDCTL-linux-$arch.tar.gz" |
      tar -zx nerdctl -C ".download/nerdctl/$ARCH"; then
      chmod a+x ".download/nerdctl/$ARCH/nerdctl"
    else
      echo "====download and targz nerdctl failed!===="
    fi
  }
  ;;
docker | cri-dockerd)
  if [[ -n $CRIDOCKER ]]; then
    mkdir -p ".download/docker/$ARCH" && {
      if ! wget -qO ".download/docker/$ARCH/cri-dockerd.tgz" "https://github.com/Mirantis/cri-dockerd/releases/download/v$CRIDOCKERD/cri-dockerd-$CRIDOCKERD.$ARCH.tgz"; then
        echo "====download and targz cri-dockerd failed!===="
      fi
    }
  else
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
    mkdir -p ".download/docker/$ARCH" && {
      if ! wget -qO ".download/docker/$ARCH/docker.tgz" "https://download.docker.com/linux/static/stable/$DOCKER_ARCH/docker-$DOCKER.tgz"; then
        echo "====download and targz docker failed!===="
      fi
    }
  fi
  ;;
esac

mkdir -p ".download/library/$ARCH" && {
  if ! wget -qO ".download/library/$ARCH/library.tar.gz" "https://github.com/labring/cluster-image/releases/download/depend/library-2.5-linux-$ARCH.tar.gz"; then
    echo "====download library failed!===="
  fi
}

mkdir -p ".download/registry/$ARCH" && {
  if ! wget -qO ".download/registry/$ARCH/registry.tar" "https://github.com/labring/cluster-image/releases/download/depend/registry-$ARCH.tar"; then
    echo "====download registry failed!===="
  fi
}

mkdir -p ".download/lsof/$ARCH" && {
  if ! wget -qO ".download/lsof/$ARCH/lsof" "https://github.com/labring/cluster-image/releases/download/depend/lsof-linux-$ARCH"; then
    chmod a+x ".download/lsof/$ARCH/lsof"
  else
    echo "====download lsof failed!===="
  fi
}
