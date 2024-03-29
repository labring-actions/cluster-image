#!/bin/bash
cp -rvf "${1}"/bin/* /opt/containerd/bin/
cp -rvf "${1}"/lib/* /opt/containerd/lib/

CONFIG_FILE="/etc/containerd/config.toml"
BACKUP_FILE="/etc/containerd/config.toml.bak"

# 备份原始配置文件
sudo cp "$CONFIG_FILE" "$BACKUP_FILE"

# 添加 WasmEdge 运行时配置
if ! grep -q "io.containerd.wasmedge.v1" "$CONFIG_FILE"; then
    sudo sed -i '/\[plugins."io.containerd.grpc.v1.cri".containerd.runtimes\]/a \ \ \ \ \ \ \ \ \[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.wasmedge]\n          runtime_type = "io.containerd.wasmedge.v1"' "$CONFIG_FILE"
    echo "WasmEdge runtime configuration added."
    sudo systemctl restart containerd
    echo "Containerd restarted."
else
    echo "WasmEdge runtime configuration already exists."
fi

kubectl apply -f - <<EOF
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  name: wasmedge
handler: wasmedge
EOF
