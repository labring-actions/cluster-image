### How to run affine 

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


### Show status

```text
root@sealos01:~# kubectl get all -n affine-system
NAME                          READY   STATUS    RESTARTS   AGE
pod/affine-6b66b47f76-zlpkq   1/1     Running   0          14m

NAME                TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE
service/affine      ClusterIP   10.96.3.192   <none>        3000/TCP         16m
service/affine-np   NodePort    10.96.2.232   <none>        3000:30008/TCP   16m

NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/affine   1/1     1            1           16m

NAME                                DESIRED   CURRENT   READY   AGE
replicaset.apps/affine-6b66b47f76   1         1         1       14m
replicaset.apps/affine-d6bd7d4c5    0         0         0       16m
```
