#!/bin/bash
helm upgrade -i zot oci://"$ZOT_IP":"$ZOT_PORT"/helm-charts/zot  -n zot --create-namespace -f zot-acl.yaml --set image.tag=v1.4.3   --insecure-skip-tls-verify
sealos run labring/zot-upload:main -f
export ZOT_PORT=$(kubectl get --namespace zot -o jsonpath="{.spec.ports[0].port}" services zot)
export ZOT_IP=$(kubectl get --namespace zot -o jsonpath="{.spec.clusterIP}" services zot)
helm upgrade -i kubeblocks oci://"$ZOT_IP":"$ZOT_PORT"/helm-charts/kubeblocks --post-renderer=./replace-chart.py --set image.tools.repository=labring/docker-kubeblocks-tools --insecure-skip-tls-verify  -n kb-system --create-namespace
