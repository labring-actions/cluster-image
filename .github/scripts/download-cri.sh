#!/bin/bash
mkdir -p .download/library/${arch}
wget https://github.com/labring/cluster-image/releases/download/depend/library-2.5-linux-${arch}.tar.gz --no-check-certificate -O .download/library/${arch}/library.tar.gz
if [ $? != 0 ]; then
   echo "====download library failed!===="
   exit 1
fi

mkdir -p .download/registry/${arch}
wget https://github.com/labring/cluster-image/releases/download/depend/registry-${arch}.tar --no-check-certificate -O .download/registry/${arch}/registry.tar
if [ $? != 0 ]; then
   echo "====download registry failed!===="
   exit 1
fi


mkdir -p .download/containerd/${arch}
wget https://github.com/containerd/containerd/releases/download/v${containerdVersion}/cri-containerd-cni-${containerdVersion}-linux-${arch}.tar.gz --no-check-certificate -O cri-containerd-cni-linux.tar.gz
tar -zxf  cri-containerd-cni-linux.tar.gz
rm -rf etc opt && mkdir -p usr/bin
cp -rf usr/local/bin/* usr/bin/
cp -rf usr/local/sbin/* usr/bin/ && rm -rf usr/bin/critest && rm -rf cri-containerd-cni-linux.tar.gz usr/local
tar -czf cri-containerd-linux.tar.gz usr && rm -rf usr
mv cri-containerd-linux.tar.gz .download/containerd/${arch}/
if [ $? != 0 ]; then
   echo "====download and targz containerd failed!===="
   exit 1
fi

mkdir -p .download/nerdctl/${arch}
wget https://github.com/containerd/nerdctl/releases/download/v${nerdctlVersion}/nerdctl-${nerdctlVersion}-linux-${arch}.tar.gz -O  nerdctl.tar.gz
tar xf nerdctl.tar.gz nerdctl
mv nerdctl .download/nerdctl/${arch}/
chmod a+x .download/nerdctl/${arch}/nerdctl
rm -rf nerdctl.tar.gz
if [ $? != 0 ]; then
   echo "====download and targz nerdctl failed!===="
   exit 1
fi


mkdir -p .download/lsof/${arch}
wget https://github.com/labring/cluster-image/releases/download/depend/lsof-linux-${arch} --no-check-certificate -O .download/lsof/${arch}/lsof
chmod a+x .download/lsof/${arch}/lsof

if [ $? != 0 ]; then
   echo "====download lsof failed!===="
   exit 1
fi
