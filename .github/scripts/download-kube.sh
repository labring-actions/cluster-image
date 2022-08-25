#!/bin/bash

#!/bin/bash

set -e

ARCH=${arch?}
CRI_TYPE=${criType?}
KUBE=${kubeVersion?}

mkdir -p ".download/kube/$ARCH" && {
  if wget -qP ".download/kube/$ARCH" "https://storage.googleapis.com/kubernetes-release/release/v$KUBE/bin/linux/$ARCH/kubectl" &&
    wget -qP ".download/kube/$ARCH" "https://storage.googleapis.com/kubernetes-release/release/v$KUBE/bin/linux/$ARCH/kubelet" &&
    wget -qP ".download/kube/$ARCH" "https://storage.googleapis.com/kubernetes-release/release/v$KUBE/bin/linux/$ARCH/kubeadm"; then
    chmod a+x ".download/kube/$ARCH"/*
  else
    echo "====download kube failed!===="
  fi
}

if wget -qP /usr/bin "https://storage.googleapis.com/kubernetes-release/release/v$KUBE/bin/linux/amd64/kubeadm"; then
  chmod a+x /usr/bin/kubeadm
  mkdir -p .download/images && {
    if ! kubeadm config images list --kubernetes-version "$KUBE" 2>/dev/null >>.download/images/DefaultImageList; then
      echo "====get kubeadm images failed!===="
    fi
    if ! sed -i "s/v0.0.0/v$KUBE/g" "$CRI_TYPE/Kubefile"; then
      echo "====sed kubernetes failed!===="
    fi
  }
else
  echo "====download kubeadm failed!===="
fi
