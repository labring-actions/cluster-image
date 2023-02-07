#!/bin/bash
arch=${1:-amd64}
version=1.16.2

mkdir -p opt/ istio/
wget -q https://github.com/istio/istio/releases/download/${version}/istio-${version}-linux-${arch}.tar.gz
tar -zxf istio-${version}-linux-${arch}.tar.gz -C istio/
mv istio/istio-${version}/bin/istioctl opt/
chmod a+x opt/istioctl
rm -rf istio-${version}-linux-${arch}.tar.gz
rm -rf istio

cat <<EOF >"Kubefile"
FROM scratch
COPY . .
CMD ["cp opt/istioctl /usr/bin/","istioctl install"]
EOF
