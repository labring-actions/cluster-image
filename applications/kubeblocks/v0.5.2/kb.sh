#!/bin/bash
cp -rf opt/kbcli  /usr/local/bin
helm upgrade -i zot oci://"$ZOT_IP":"$ZOT_PORT"/helm-charts/zot  -n zot --create-namespace -f zot-acl.yaml --set image.tag=v1.4.3   --insecure-skip-tls-verify
sealos run labring/zot-upload:main -f
export ZOT_PORT=$(kubectl get --namespace zot -o jsonpath="{.spec.ports[0].port}" services zot)
export ZOT_IP=$(kubectl get --namespace zot -o jsonpath="{.spec.clusterIP}" services zot)
helm install kubeblocks oci://"$ZOT_IP":"$ZOT_PORT"/kubeblocks --post-renderer=./replace-chart.py --insecure-skip-tls-verify  -n kb-system --create-namespace
