## nfs-subdir-external-provisioner

Dynamic sub-dir volume provisioner on a remote NFS server.

## Install

```shell
sealos run docker.io/labring/nfs-subdir-external-provisioner:v4.0.18
```

custome values
```shell
sealos run docker.io/labring/nfs-subdir-external-provisioner:v4.0.18 -e HELM_OPTS="--set nfs.server=10.0.0.5 --set nfs.path=/nfs-storage"
```

Get pods status

```shell
$ kubectl -n nfs-provisioner get pods 
NAME                                               READY   STATUS    RESTARTS   AGE
nfs-subdir-external-provisioner-6545794f8f-v4j69   1/1     Running   0          11m
```

Get storageclass status

```shell
$ kubectl get sc
NAME                         PROVISIONER                                     RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
nfs-client                   cluster.local/nfs-subdir-external-provisioner   Delete          Immediate              true                   11m
```

## Uinstall

```shell
sealos run docker.io/labring/nfs-subdir-external-provisioner:v4.0.18 -e uninstall=true
```
