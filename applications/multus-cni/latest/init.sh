#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

mkdir -p manifests
wget -q -N -P manifests/ https://raw.githubusercontent.com/k8snetworkplumbingwg/multus-cni/${VERSION}/deployments/multus-daemonset-thick.yml

# insert cni-plugin init-container config to helm chart
readonly cni_latest_version=v${cnilatest:-$(
  until curl -sL "https://api.github.com/repos/containernetworking/plugins/releases/latest"; do sleep 3; done | grep tarball_url | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' | cut -dv -f2
)}
cni_plugin_image="docker.io/labring/docker-cni-plugins:${cni_latest_version}"
cat << EOF | sed -i '/^\s*initContainers/ r /dev/stdin' manifests/multus-daemonset-thick.yml
        - name: install-cni-plugin-sealos
          image: "${cni_plugin_image}"
          command: ["/bin/sh"]
          args: ["-c", "cp -f /cni-plugins/* /opt/cni/bin/"]
          volumeMounts:
          - name: cni-plugin-sealos
            mountPath: /opt/cni/bin
EOF
cat << EOF | sed -i '/^\s*volumes/ r /dev/stdin' manifests/multus-daemonset-thick.yml
        - name: cni-plugin-sealos
          hostPath:
            path: /opt/cni/bin
EOF
