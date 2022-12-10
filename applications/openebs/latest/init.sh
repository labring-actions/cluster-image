#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

helm repo add openebs https://openebs.github.io/charts
chart_version=`helm search repo --versions --regexp '\vopenebs/openebs\v' |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1`
rm -rf charts/
helm pull openebs/openebs --version=${chart_version} -d charts/ --untar
utils_tag=$(helm show values charts/openebs --jsonpath {.helper.imageTag})
mkdir -p images/shim
echo "openebs/linux-utils:$utils_tag" >images/shim/openebsImages

cat <<'EOF' >"Kubefile"
FROM scratch
COPY charts charts
COPY registry registry
CMD ["helm upgrade -i openebs charts/openebs -n openebs --create-namespace --set localprovisioner.hostpathClass.isDefaultClass=true"]
EOF
