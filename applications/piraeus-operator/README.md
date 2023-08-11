## Piraeus Operator

The Piraeus Operator manages [LINSTOR](https://github.com/LINBIT/linstor-server) clusters in Kubernetes.

## Install

```shell
sealos run docker.io/labring/piraeus-operator:v2.1.1
```

custome values
```shell
sealos run docker.io/labring/piraeus-operator:v2.1.1 --env HELM_OPTS="--set installCRDs=true" --env placementCount=2
```

Get pods status

```shell
root@node1:~# kubectl -n piraeus-datastore get pods 
NAME                                                   READY   STATUS    RESTARTS   AGE
ha-controller-bmz2w                                    1/1     Running   0          9h
ha-controller-rn54t                                    1/1     Running   0          9h
ha-controller-x6sh9                                    1/1     Running   0          9h
linstor-controller-97cd7495c-rqgzd                     1/1     Running   0          9h
linstor-csi-controller-7f85967cd9-8dq7t                7/7     Running   0          9h
linstor-csi-node-dxpc4                                 3/3     Running   0          9h
linstor-csi-node-p9f62                                 3/3     Running   0          9h
linstor-csi-node-q8dwv                                 3/3     Running   0          9h
node1                                                  2/2     Running   0          9h
node2                                                  2/2     Running   0          9h
node3                                                  2/2     Running   0          9h
piraeus-operator-controller-manager-6f8974c495-fk5ql   2/2     Running   0          9h
```

Get storageclass

```shell
root@node1:~# kubectl get sc
NAME                        PROVISIONER              RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
piraeus-storage (default)   linstor.csi.linbit.com   Delete          WaitForFirstConsumer   true                   9h
```

## Uinstall

```shell
helm -n piraeus-datastore uninstall piraeus-operator
```
