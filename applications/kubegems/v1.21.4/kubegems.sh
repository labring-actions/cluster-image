#!/bin/bash
helm upgrade --install kubegems-installer --namespace kubegems-installer --create-namespace --set global.storageClass=local-hostpath --set installer.image.tag=v1.21.4 kubegems/kubegems-installer
helm upgrade --install kubegems --namespace kubegems --create-namespace --set global.storageClass=local-hostpath --set global.kubegemsVersion=v1.21.4 --set ingress.enable=false --set dashboard.service.type=NodePort  kubegems/kubegems
