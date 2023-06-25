#!/bin/bash
sealos run labring/zot-upload:main -f
export ZOT_PORT=$(kubectl get --namespace zot -o jsonpath="{.spec.ports[0].port}" services zot)
export ZOT_IP=$(kubectl get --namespace zot -o jsonpath="{.spec.clusterIP}" services zot)
helm upgrade -i zot oci://"$ZOT_IP":"$ZOT_PORT"/helm-charts/zot  -n zot --create-namespace -f zot-acl.yaml --set image.tag=v1.4.3   --insecure-skip-tls-verify
helm upgrade kubeblocks oci://"$ZOT_IP":"$ZOT_PORT"/kubeblocks --install --namespace kb-system --create-namespace --insecure-skip-tls-verify --set addonChartLocationBase=oci://"$ZOT_IP":"$ZOT_PORT"
