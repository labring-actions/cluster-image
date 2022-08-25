#!/bin/bash

set -e

ARCH=${arch?}
CRI_TYPE=${criType?}

SEALOS=${sealos?}

ipvsImage="ghcr.io/labring/lvscare:v$SEALOS"

if wget -qO dl.tgz "https://github.com/labring/sealos/releases/download/v$SEALOS/sealos_${SEALOS}_linux_amd64.tar.gz"; then
  mkdir -p ".download/shim/$ARCH" && {
    if ! tar -zxf dl.tgz image-cri-shim -C ".download/shim/$ARCH"; then
      echo "====download and targz image-cri-shim failed!===="
    fi
  }
  mkdir -p ".download/sealctl/$ARCH" && {
    if ! tar -zxf dl.tgz sealctl -C ".download/sealctl/$ARCH"; then
      echo "====targz sealctl failed!===="
    fi
  }
  rm dl.tgz
fi

mkdir -p ".download/images" && {
  if docker pull "$ipvsImage"; then
    sed -i "s#__lvscare__#$ipvsImage#g" "$CRI_TYPE/Kubefile"
    echo "$ipvsImage" >>.download/images/LvscareImageList
  else
    echo "====get lvscare image failed!===="
  fi
}
