#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
readonly ARCH=${1:-amd64}
readonly NAME=${2:-$(basename "${PWD%/*}")}
inVERSION=${3:-$(basename "$PWD")}

if [[ $inVERSION =~ ^v[.0-9]+$ ]]; then
  readonly VERSION=$inVERSION
else
  readonly VERSION="v$inVERSION"
  readonly XY_LATEST=true
fi

repo_url=" https://flannel-io.github.io/flannel/"
repo_name="flannel/flannel"
chart_name="flannel"

function check_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "$1 is required, exiting the script"
    exit 1
  fi
}

function check_version(){
  rm -rf charts
  helm repo add ${chart_name} ${repo_url} --force-update 1>/dev/null

  # Check version number exists
  all_versions=$(helm search repo --versions --regexp "\v"${repo_name}"\v" | awk '{print $3}' | grep -v VERSION)
  if ! echo "$all_versions" | grep -qw "${VERSION}"; then
    echo "Error: Exit, the provided version ${VERSION} does not exist in helm repo, get available version with: helm search repo ${repo_name} --versions"
    exit 1
  fi
}

function init(){
  # Find the chart version through the app version
  chart_version=$(helm search repo --versions --regexp "\v"${repo_name}"\v" |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1)

  # Pull helm charts to local
  helm pull ${repo_name} --version=${chart_version} -d charts --untar
  if [ $? -eq 0 ]; then
    echo "init success, next run sealos build"
  fi
  yq e -iN '.podCidr="100.64.0.0/10"' charts/flannel/values.yaml
  if [[ "$XY_LATEST" == true ]]; then
  cni_tag=$({ curl --silent "https://api.github.com/repos/flannel-io/cni-plugin/releases/latest" | grep -E 'tag/v[0-9.]+' || echo v1.2.0; } | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}') yq e -i '.podCidr="172.31.0.0/17"|.flannel.image_cni.tag=strenv(cni_tag)' charts/flannel/values.yaml
    cat <<EOF | sed -i '/^\s*initContainers/ r /dev/stdin' charts/flannel/templates/daemonset.yaml
      - name: install-cni-plugins
        image: docker.io/labring4docker/cni-plugins:$({ curl --silent "https://api.github.com/repos/containernetworking/plugins/releases/latest" | grep tarball_url || echo v1.3.0; } | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}')
        command: ["/bin/sh"]
        args: ["-c", "cp -au /cni-plugins/* /cni-plugin/"]
        volumeMounts:
        - name: cni-plugin
          mountPath: /cni-plugin
EOF
  cat <<EOF >Kubefile
FROM scratch
COPY charts charts
COPY registry registry
CMD ["helm upgrade -i flannel charts/flannel -n kube-system"]
EOF
  exit
fi
}

function main() {
  if [ $# -ne 3 ]; then
    echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
    exit 1
  else
    check_command helm
    check_version
    init
  fi
}

main "$@"
