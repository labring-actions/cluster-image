#!/bin/bash
arch=${1:-amd64}
version=1.16.2

mkdir -p opt/ manifests/ images/shim/
wget -q https://github.com/istio/istio/releases/download/${version}/istio-${version}-linux-${arch}.tar.gz
tar -zxf istio-${version}-linux-${arch}.tar.gz -C manifests/
mv manifests/istio-${version}/bin/istioctl opt/
chmod a+x opt/istioctl
rm -rf istio-${version}-linux-${arch}.tar.gz

cat >images/shim/istioImages<<EOF
docker.io/istio/proxyv2:${version}
docker.io/istio/pilot:${version}
docker.io/library/install-cni:${version}
EOF

cat <<EOF >"Kubefile"
FROM scratch
COPY . .
CMD ["cp opt/istioctl /usr/bin/","istioctl install --set profile=demo -y"]
EOF
