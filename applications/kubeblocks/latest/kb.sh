#!/bin/bash
cp -rf opt/kbcli /usr/local/bin/
helm upgrade -i kubeblocks-checks charts/kubeblocks-checks -n kb-system --create-namespace
bash for-range.sh
helm upgrade -i kubeblocks charts/kubeblocks-0.5.3.tgz --set snapshot-controller.enabled=false,addonChartLocationBase=oci://zot.zot.svc.cluster.local:8443/helm-charts --insecure-skip-tls-verify  -n kb-system --create-namespace
