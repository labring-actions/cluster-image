
```shell
sealos run labring/kubernetes:v1.24.0 labring/calico:v3.22.1 --single
NODENAME=$(kubectl get nodes -ojsonpath='{.items[0].metadata.name}')
NODEIP=$(kubectl get nodes -ojsonpath='{.items[0].status.addresses[0].address}')
echo "NodeName=$NODENAME,NodeIP=$NODEIP"
kubectl taint node $NODENAME node-role.kubernetes.io/master-
kubectl taint node $NODENAME node-role.kubernetes.io/control-plane-

sealos run labring/helm:v3.8.2
sealos run labring/openebs:v1.9.0

sealos run docker.io/labring/affine:latest

PORT=$(kubectl -n affine-system get svc affine-np -ojsonpath='{.spec.ports[0].nodePort}')
ADDRESS=$(kubectl get nodes -ojsonpath='{.items[0].status.addresses[0].address}')
echo "visit http://$ADDRESS:$PORT"
```
