#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

readonly CONFIG_FILE="/etc/containerd/config.toml"

mkdir -p /opt/containerd
sudo cp -av bin /opt/containerd
if [[ -s lib ]]; then
  sudo cp -av lib /opt/containerd
fi

# 添加 WasmRuntime 运行时配置
if ! grep -q io.containerd.wasmedge.v1 "$CONFIG_FILE"; then
  sudo sed -i.bak '/.containerd.runtimes]$/a\        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runwasi-wasmedge]\n          runtime_type = "io.containerd.wasmedge.v1"' "$CONFIG_FILE"
  echo "WasmRuntime runtime configuration added."
  sudo systemctl restart containerd
  echo "Containerd restarted."
else
  echo "WasmRuntime runtime configuration already exists."
fi

kubectl apply -f - <<EOF
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  name: runwasi-wasmedge
handler: runwasi-wasmedge
EOF
