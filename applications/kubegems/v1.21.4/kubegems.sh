#!/bin/bash
helm upgrade --install kubegems-installer --namespace kubegems-installer --create-namespace --set global.storageClass=local-hostpath --set installer.image.tag=v1.21.4 kubegems/kubegems-installer
helm upgrade --install kubegems --namespace kubegems --create-namespace --set global.storageClass=local-hostpath --set global.imageRegistry=sealos.hub:5000 --set global.kubegemsVersion=v1.21.4 --set ingress.enable=false --set dashboard.service.type=NodePort  kubegems/kubegems

PORT=$(kubectl -n kubegems get svc kubegems-dashboard -ojsonpath='{.spec.ports[0].nodePort}')
ADDRESS=$(kubectl get nodes -ojsonpath='{.items[0].status.addresses[0].address}')
echo "visit http://$ADDRESS:$PORT, user: admin password: demo!@#admin"
