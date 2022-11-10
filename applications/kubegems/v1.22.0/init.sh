#!/bin/bash
helm repo add kubegems https://charts.kubegems.io/kubegems
helm pull kubegems/kubegems-installer --untar -d kubegems/
helm pull kubegems/kubegems --untar -d kubegems/
echo "download kubegems charts success"
