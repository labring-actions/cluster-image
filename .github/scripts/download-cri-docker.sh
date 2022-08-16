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

to_download_arch() {
    case $arch in
        amd64)
            DOCKER_ARCH=x86_64
            ;;
        arm64)
            DOCKER_ARCH=aarch64
            ;;
        *)
            fatal "Unsupported architecture $arch"
    esac
}

to_download_arch
echo "download arch : $DOCKER_ARCH"
mkdir -p .download/docker/${arch}

wget https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/docker-${dockerVersion}.tgz --no-check-certificate -O docker.tgz
if [ $? != 0 ]; then
   echo "====download and targz docker failed!===="
   exit 1
fi
mv docker.tgz .download/docker/${arch}/


mkdir -p .download/lsof/${arch}
wget https://github.com/labring/cluster-image/releases/download/depend/lsof-linux-${arch} --no-check-certificate -O .download/lsof/${arch}/lsof
if [ $? != 0 ]; then
   echo "====download lsof failed!===="
   exit 1
fi
chmod a+x .download/lsof/${arch}/lsof

