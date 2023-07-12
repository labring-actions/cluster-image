#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}
rm -rf charts
rm -rf gpu-operator
rm -rf manifests
helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
# Get the chart version from the app version
chart_version=`helm search repo --versions --regexp '\vnvidia/gpu-operator\v' |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1`
helm pull nvidia/gpu-operator --version=${chart_version} -d charts/ --untar
mv charts/gpu-operator .
mkdir -p "manifests"
helm template gpu-operator gpu-operator  --values gpu-operator/values.yaml  --set driver.enabled=false  --debug > manifests/gpu-operator.yaml

cat manifests/gpu-operator.yaml | grep 'repository:' | awk '{print $2}' > repositories.txt
cat manifests/gpu-operator.yaml | grep 'image:'  | awk '{print $2}'| grep -v ":" > images.txt
cat manifests/gpu-operator.yaml | grep 'version:' | grep -v "/" | awk '{print $2}' > versions.txt
paste -d/ repositories.txt images.txt > temp.txt
paste -d: temp.txt versions.txt > images_list.txt
rm temp.txt

cat manifests/gpu-operator.yaml | grep 'image:'  | awk '{print $2}'| grep  ":" >> images_list.txt

# 获取 Ubuntu 版本号
ubuntu_version=$(cat images_list.txt | grep -o 'ubuntu[0-9.]*' | head -1)
sed -i "/nvidia\/driver/ s/$/-${ubuntu_version}/" images_list.txt

rm -rf repositories.txt images.txt versions.txt
rm -rf manifests
sed -i 's/"//g' images_list.txt

cat images_list.txt

mkdir -p "images/shim"
mv images_list.txt images/shim/gpuImageList

cat <<EOF >"Kubefile"
FROM scratch
ENV TOOLKIT_VERSION=false
COPY registry registry
COPY gpu-operator charts/gpu-operator
CMD ["helm install --generate-name -n gpu-operator --create-namespace charts/gpu-operator --set driver.enabled=false --set toolkit.enabled=\$(TOOLKIT_VERSION)"]
EOF
