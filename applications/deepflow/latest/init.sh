#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

repo_url="https://deepflowys.github.io/deepflow-charts"
repo_name="deepflow/deepflow"
app_name="deepflow"

# Delete v in version tag
app_version=$(echo ${VERSION} | sed 's/.//')

rm -rf opt/ charts/ && mkdir -p opt/ charts/
wget -qO opt/deepflow-ctl https://deepflow-ce.oss-accelerate.aliyuncs.com/bin/ctl/latest/linux/${ARCH}/deepflow-ctl
chmod a+x opt/deepflow-ctl

helm repo add ${app_name} ${repo_url}
# Get all helm chart app versions
app_versions=$(helm search repo --versions --regexp "\v${repo_name}\v" | awk '{print $3}' | grep -v VERSION)

if [[ $VERSION = "latest" ]]; then
  helm pull ${repo_name} --untar -d charts/
# Check whether the versions in issue comments match app_versions
elif [[ $app_versions != *$app_version* ]]; then
  echo "Only support app_versions: $app_versions"
  exit 1
else
  chart_version=`helm search repo --versions --regexp "\v${repo_name}\v" |grep ${app_version} | awk '{print $2}' | sort -rn | head -n1`
  helm pull ${repo_name} --version=${chart_version} --untar -d charts/
fi

cat <<EOF >"Kubefile"
FROM scratch
COPY charts charts
COPY registry registry
CMD ["mv opt/deepflow-ctl /usr/bin/","helm upgrade -i deepflow charts/deepflow -n deepflow --create-namespace"]
EOF
