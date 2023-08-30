#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

declare -r ARCH=${1:-amd64}
declare -r NAME=${2:-$(basename "${PWD%/*}")}

inVERSION=${3:-$(basename "$PWD")}

if [[ $inVERSION =~ ^v[.0-9]+$ ]]; then
  declare -r VERSION=$inVERSION
else
  declare -r VERSION="v$inVERSION"
  declare -r XY_LATEST=true
fi

rm -rf charts && mkdir -p charts
wget -qO- https://github.com/flannel-io/flannel/archive/refs/tags/$VERSION.tar.gz | tar -xz && mv flannel-*/chart/kube-flannel charts/flannel

# delete "---" for merge support
yq e -iN '.podCidr="100.64.0.0/10"' charts/flannel/values.yaml

# insert cni-plugin init-container config to helm chart
readonly cni_latest_version=v${cnilatest:-$(
  until curl -sL "https://api.github.com/repos/containernetworking/plugins/releases/latest"; do sleep 3; done | grep tarball_url | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' | cut -dv -f2
)}
cni_plugin_image="docker.io/labring/docker-cni-plugins:${cni_latest_version}"
if [[ "$XY_LATEST" == true ]]; then
  yq e -i '.podCidr="172.31.0.0/17"' charts/flannel/values.yaml
  cat <<EOF | sed -i '/^\s*initContainers/ r /dev/stdin' charts/flannel/templates/daemonset.yaml
      - name: install-cni-plugins
        image: ${cni_plugin_image}
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
cat <<EOF | sed -i '/^\s*initContainers/ r /dev/stdin' charts/flannel/templates/daemonset.yaml
      - name: install-cni-plugin-sealos
        image: "${cni_plugin_image}"
        command: ["/bin/sh"]
        args: ["-c", "cp -f /cni-plugins/* /opt/cni/bin/"]
        volumeMounts:
        - name: cni-plugin-sealos
          mountPath: /opt/cni/bin
EOF
cat <<EOF | sed -i '/^\s*volumes/ r /dev/stdin' charts/flannel/templates/daemonset.yaml
      - name: cni-plugin-sealos
        hostPath:
          path: /opt/cni/bin
EOF
