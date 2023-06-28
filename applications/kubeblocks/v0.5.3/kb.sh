#!/bin/bash
helm upgrade -i kubeblocks-checks charts/kubeblocks-checks -n kb-system --create-namespace
bash for-range.sh
export ZOT_PORT=$(kubectl get --namespace zot -o jsonpath="{.spec.ports[0].port}" services zot)
export ZOT_IP=$(kubectl get --namespace zot -o jsonpath="{.spec.clusterIP}" services zot)
helm upgrade -i kubeblocks oci://"$ZOT_IP":"$ZOT_PORT"/helm-charts/kubeblocks  --set snapshot-controller.enabled=false,addonChartLocationBase=oci://zot.zot.svc.cluster.local:8443/helm-charts --insecure-skip-tls-verify  -n kb-system --create-namespace
