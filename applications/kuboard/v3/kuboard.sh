#!/bin/bash
kubectl create cm kuboard-shell -n kuboard  --from-file=etcd.sh=manifests/etcd.sh  --from-file=kuboard.sh=manifests/kuboard.sh --dry-run=client  -o yaml  > manifests/kuboard-shell.yaml
kubectl apply -f manifests/kuboard-v3.yaml
kubectl apply -f manifests/kuboard-shell.yaml
PORT=$(kubectl -n kuboard get svc kuboard-v3 -ojsonpath='{.spec.ports[0].nodePort}')
ADDRESS=$(kubectl get nodes -ojsonpath='{.items[0].status.addresses[0].address}')
echo "Visit Kuboard v3 : http://$ADDRESS:$PORT, user: admin password: Kuboard123"
