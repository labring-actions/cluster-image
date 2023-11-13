#!/bin/bash
cp -rvf "${1}"/bin/* /opt/containerd/bin/
if [[ -s "${1}"/lib ]]; then cp -rvf "${1}"/lib/* /opt/containerd/lib/ ; fi

CONFIG_FILE="/etc/containerd/config.toml"
BACKUP_FILE="/etc/containerd/config.toml.bak"

# 备份原始配置文件
sudo cp "$CONFIG_FILE" "$BACKUP_FILE"

# 添加 WasmRuntime 运行时配置
if ! grep -q "io.containerd.wasmedge.v1" "$CONFIG_FILE"; then
    sudo sed -i '/\[plugins."io.containerd.grpc.v1.cri".containerd.runtimes\]/a \ \ \ \ \ \ \ \ \[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runwasi-wasmtime]\n          runtime_type = "io.containerd.wasmtime.v1"' "$CONFIG_FILE"
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
  name: runwasi-wasmtime
handler: runwasi-wasmtime
EOF
