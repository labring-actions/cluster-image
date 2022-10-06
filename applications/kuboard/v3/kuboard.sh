#!/bin/bash
PORT=$(kubectl -n kuboard get svc kuboard-v3 -ojsonpath='{.spec.ports[0].nodePort}')
ADDRESS=$(kubectl get nodes -ojsonpath='{.items[0].status.addresses[0].address}')
echo "visit http://$ADDRESS:$PORT, user: admin password: Kuboard123"
