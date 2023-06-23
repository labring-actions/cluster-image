#!/bin/bash

export readonly USERNAME=${1:-admin}
export readonly PASSWORD=${1:-admin}

ZOT_PORT=$(kubectl get --namespace zot -o jsonpath="{.spec.ports[0].port}" services zot)
ZOT_IP=$(kubectl get --namespace zot -o jsonpath="{.spec.clusterIP}" services zot)
echo "https://$ZOT_IP:$ZOT_PORT"

# shellcheck disable=SC2154
helm registry  login  "$ZOT_IP":"$ZOT_PORT" --insecure -u "${USERNAME}" -p "${PASSWORD}"

# 设置你的目标目录为上级目录
target_dir="../../"

# 使用 `find` 来找到所有在 `workdir/charts` 目录下的子目录
charts_dirs=$(find $target_dir -maxdepth 4 -type d -name "charts")

# 使用 `for` 循环遍历所有找到的 `charts` 目录
for dir in $charts_dirs; do
    # 再次使用 `find` 来找到 `charts` 目录下的第一级目录，并使用 `realpath` 获取其绝对路径
    sub_dirs=$(find "$dir" -maxdepth 1 -mindepth 1 -type d -exec realpath {} \;)
    # 使用 `for` 循环遍历所有找到的第一级目录并进行输出
    for sub_dir in $sub_dirs; do
        echo "Processing chart $sub_dir"
        helm package "$sub_dir"
    done
done

find . -name "*.tgz" -exec helm  push  {}  oci://"$ZOT_IP":"$ZOT_PORT" --insecure-skip-tls-verify \;
