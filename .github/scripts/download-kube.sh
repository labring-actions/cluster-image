#!/bin/bash
mkdir -p /tmp/kube/${arch}
wget https://storage.googleapis.com/kubernetes-release/release/v${kubeVersion}/bin/linux/${arch}/kubectl -O /tmp/kube/${arch}/kubectl
wget https://storage.googleapis.com/kubernetes-release/release/v${kubeVersion}/bin/linux/${arch}/kubelet -O /tmp/kube/${arch}/kubelet
wget https://storage.googleapis.com/kubernetes-release/release/v${kubeVersion}/bin/linux/${arch}/kubeadm -O /tmp/kube/${arch}/kubeadm
chmod a+x /tmp/kube/${arch}/*
if [ $? != 0 ]; then
   echo "====download kube failed!===="
   exit 1
fi

mkdir -p /tmp/kubeadm /tmp/images/
wget https://storage.googleapis.com/kubernetes-release/release/v${kubeVersion}/bin/linux/amd64/kubeadm -O /tmp/kubeadm/kubeadm
sudo mv /tmp/kubeadm/kubeadm /usr/bin/
chmod a+x /usr/bin/kubeadm
if [ $? != 0 ]; then
   echo "====download kubeadm failed!===="
   exit 1
fi

kubeadm config images list --kubernetes-version ${kubeVersion}  2>/dev/null>> /tmp/images/DefaultImageList
if [ $? != 0 ]; then
   echo "====get kubeadm images failed!===="
   exit 1
fi
sed -i "s/v0.0.0/v${kubeVersion}/g" rootfs/Kubefile
if [ $? != 0 ]; then
   echo "====sed kubernetes failed!===="
   exit 1
fi
