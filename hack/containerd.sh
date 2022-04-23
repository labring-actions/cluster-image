#!/bin/bash
kubeVersion=${1:-1.22.8}
containerdVersion=1.6.2
ipvsImage=ghcr.io/sealyun/lvscare:v1.1.3-beta.2
os=linux
arch=${2:-amd64}
#https://github.91chi.fun//
repo=${3:-docker.io/cuisongliu}
proxy=${4:-}
# init dir
mkdir -p rootfs/bin && mkdir -p rootfs/opt && mkdir -p rootfs/registry && mkdir -p rootfs/images/shim && mkdir -p rootfs/cri/lib64
cp -rf runtime/rootfs/* rootfs/
cp -rf runtime/containerd/* rootfs/
# library install
wget https://sealyun-home.oss-accelerate.aliyuncs.com/images/library-2.5-$os-$arch.tar.gz --no-check-certificate -O library.tar.gz
tar xf library.tar.gz && rm -rf library.tar.gz
cp -rf library/bin/*    rootfs/bin/
ls -l  rootfs/bin/
cp -rf library/lib64/  rootfs/cri/lib64/lib
ls -l rootfs/cri/lib64/lib
rm -rf library
cd rootfs/cri/lib64 && tar -czvf containerd-lib.tar.gz lib && rm -rf lib && cd ../../../
#kube install
wget https://storage.googleapis.com/kubernetes-release/release/v$kubeVersion/bin/$os/$arch/kubectl -O rootfs/bin/kubectl
wget https://storage.googleapis.com/kubernetes-release/release/v$kubeVersion/bin/$os/$arch/kubelet -O rootfs/bin/kubelet
wget https://storage.googleapis.com/kubernetes-release/release/v$kubeVersion/bin/$os/$arch/kubeadm -O rootfs/bin/kubeadm
# registry install
wget https://sealyun-home.oss-accelerate.aliyuncs.com/images/registry-$arch.tar --no-check-certificate -O rootfs/images/registry.tar
# cri install
wget https://github.com/containerd/containerd/releases/download/v$containerdVersion/cri-containerd-cni-$containerdVersion-linux-amd64.tar.gz --no-check-certificate -O cri-containerd-cni-linux.tar.gz
tar -zxvf  cri-containerd-cni-linux.tar.gz
rm -rf etc opt && mkdir -p usr/bin
cp -rf usr/local/bin/* usr/bin/
cp -rf usr/local/sbin/* usr/bin/ && rm -rf usr/bin/critest && rm -rf cri-containerd-cni-$os.tar.gz usr/local
tar -czvf cri-containerd-linux.tar.gz usr && rm -rf usr
mv cri-containerd-linux.tar.gz rootfs/cri/
# nerdctl install
wget ${proxy}https://github.com/containerd/nerdctl/releases/download/v0.16.0/nerdctl-0.16.0-$os-$arch.tar.gz -O  nerdctl.tar.gz
tar xf nerdctl.tar.gz
mv nerdctl rootfs/cri/
rm -rf nerdctl.tar.gz containerd-rootless*
# shim install
wget ${proxy}https://github.com/sealyun-market/image-cri-shim/releases/download/v0.0.8/image-cri-shim_0.0.8_${os}_${arch}.tar.gz -O image-cri-shim.tar.gz
mkdir -p crishim && tar -zxvf image-cri-shim.tar.gz -C crishim
mv crishim/image-cri-shim rootfs/cri/
rm -rf image-cri-shim.tar.gz crishim
# sealctl
wget https://sealyun-home.oss-accelerate.aliyuncs.com/sealos-4.0/latest/sealctl-$arch --no-check-certificate -O rootfs/opt/sealctl
# lsof
wget https://sealyun-home.oss-accelerate.aliyuncs.com/images/lsof-$os-$arch --no-check-certificate -O rootfs/opt/lsof
# images
echo "$ipvsImage" >  rootfs/images/shim/DefaultImageList
if [ ! -x ./kubeadm ];then
  wget https://storage.googleapis.com/kubernetes-release/release/v$kubeVersion/bin/linux/amd64/kubeadm
  chmod a+x kubeadm
fi
./kubeadm config images list --kubernetes-version $kubeVersion  2>/dev/null>> rootfs/images/shim/DefaultImageList
rm -rf kubeadm
# Kubefile
sed -i "s/v0.0.0/v$kubeVersion/g" ./rootfs/Kubefile
sed -i "s#__lvscare__#$ipvsImage#g" ./rootfs/Kubefile
# replace
pauseImage=$(cat ./rootfs/images/shim/DefaultImageList  | grep k8s.gcr.io/pause)
sed -i "s#__pause__#k8s.gcr.io/${pauseImage##k8s.gcr.io/}#g" ./rootfs/scripts/init.sh
sed -i "s#__pause__#sealos.hub:5000/${pauseImage##k8s.gcr.io/}#g" ./rootfs/etc/config.toml
cd rootfs
chmod  -R 0755  *
../sealos build -t $repo/oci-kubernetes:$kubeVersion-$arch --platform $os/$arch -f Kubefile  .
cd ../ && rm -rf rootfs
