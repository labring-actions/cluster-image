#!/bin/bash
kubectl apply -f manifests/kuboard-v2.yaml
ADDRESS=$(kubectl get nodes -ojsonpath='{.items[0].status.addresses[0].address}')
# 如果您参考 www.kuboard.cn 提供的文档安装 Kuberenetes，可在第一个 Master 节点上执行此命令
TOKEN=$(kubectl -n kube-system get secret $(kubectl -n kube-system get secret | grep ^kuboard-user | awk '{print $1}') -o go-template='{{.data.token}}' | base64 -d)
echo "Visit Kuboard v2 : http://$ADDRESS:32567, token: $TOKEN"

