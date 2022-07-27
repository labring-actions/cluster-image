#!/bin/bash
mkdir -p .download/kube/${arch}
wget https://storage.googleapis.com/kubernetes-release/release/v${kubeVersion}/bin/linux/${arch}/kubectl -O .download/kube/${arch}/kubectl
wget https://storage.googleapis.com/kubernetes-release/release/v${kubeVersion}/bin/linux/${arch}/kubelet -O .download/kube/${arch}/kubelet
wget https://storage.googleapis.com/kubernetes-release/release/v${kubeVersion}/bin/linux/${arch}/kubeadm -O .download/kube/${arch}/kubeadm
if [ $? != 0 ]; then
   echo "====download kube failed!===="
   exit 1
fi
chmod a+x .download/kube/${arch}/*


mkdir -p .download/kubeadm .download/images/
wget https://storage.googleapis.com/kubernetes-release/release/v${kubeVersion}/bin/linux/amd64/kubeadm -O .download/kubeadm/kubeadm
if [ $? != 0 ]; then
   echo "====download kubeadm failed!===="
   exit 1
fi
sudo mv .download/kubeadm/kubeadm /usr/bin/
chmod a+x /usr/bin/kubeadm

kubeadm config images list --kubernetes-version ${kubeVersion}  2>/dev/null>> .download/images/DefaultImageList
if [ $? != 0 ]; then
   echo "====get kubeadm images failed!===="
   exit 1
fi
sed -i "s/v0.0.0/v${kubeVersion}/g" rootfs/Kubefile
if [ $? != 0 ]; then
   echo "====sed kubernetes failed!===="
   exit 1
fi
