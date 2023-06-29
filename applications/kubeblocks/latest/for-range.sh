#!/bin/bash

ZOT_PORT=$(kubectl get --namespace zot -o jsonpath="{.spec.ports[0].port}" services zot)
ZOT_IP=$(kubectl get --namespace zot -o jsonpath="{.spec.clusterIP}" services zot)
echo "https://$ZOT_IP:$ZOT_PORT"


# 使用 `find` 来找到所有在 `workdir/charts` 目录下的 `.tgz` 文件
tgz_files=$(find charts -type f -name "*.tgz")

# 使用 `for` 循环遍历所有找到的 `.tgz` 文件
for file in $tgz_files; do
    echo "Processing chart $file"
    # 在这里你可以根据你的需求来处理这些 `.tgz` 文件
    # helm package "$file"
    helm  push $file  oci://"$ZOT_IP":"$ZOT_PORT"/helm-charts --insecure-skip-tls-verify
done
