#!/bin/bash
cp -rf opt/kbcli /usr/local/bin/
helm upgrade -i kubeblocks charts/kubeblocks-0.6.0.tgz --set snapshot-controller.enabled=false --insecure-skip-tls-verify -n kb-system --create-namespace
