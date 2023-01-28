# AFFiNE

## Basic sealos cluster installation

Refer to [Cluster installation Kubernetes](https://www.sealos.io/docs/getting-started/kuberentes-life-cycle)

## How to install 

Run a single command:

```bash
sealos run hub.sealos.cn/labring/affine:latest
```

And you should create a persistent volume for AFFiNE, here is an example for test only.

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: affine-pv
  namespace: affine-system
  labels:
    type: local
spec:
  capacity:
    storage: 10Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/tmp"
```

## How to use

After installation, a service `affine` in namespace `affine-system` in created. 

```bash
PORT=$(kubectl -n affine-system get svc affine-np -ojsonpath='{.spec.ports[0].nodePort}')
ADDRESS=$(kubectl get nodes -ojsonpath='{.items[0].status.addresses[0].address}')
echo "visit http://$ADDRESS:$PORT"
```

## Build 

Refer to [GitHub link](https://github.com/labring-actions/cluster-image/tree/main/applications/affine)

## Show status

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

For more information, please visit [the official website](https://affine.pro/)