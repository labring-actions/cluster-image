# csi-driver-nfs

This driver requires existing and already configured NFSv3 or NFSv4 server, it supports dynamic provisioning of Persistent Volumes via Persistent Volume Claims by creating a new sub directory under NFS server.

## Install

install csi-driver-nfs

```shell
sealos run docker.io/labring/csi-driver-nfs:v4.4.0
```

install csi-driver-nfs and create StorageClass
```shell
sealos run docker.io/labring/csi-driver-nfs:v4.4.0 -e server=192.168.1.10 -e share=/nfs/share
```

Get pods status

```shell
root@ubuntu:~# kubectl -n csi-driver-nfs get pods 
NAME                                   READY   STATUS    RESTARTS   AGE
csi-nfs-controller-666f64bf47-zdr65    4/4     Running   0          2m16s
csi-nfs-node-g2z42                     3/3     Running   0          2m16s
snapshot-controller-78447c9489-s56vt   1/1     Running   0          2m16s
```

Get storageclass status

```shell
root@ubuntu:~# kubectl get sc
NAME                PROVISIONER      RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
nfs-csi (default)   nfs.csi.k8s.io   Delete          Immediate           false                  5s
```

## Uninstall

```shell
helm -n csi-driver-nfs uninstall csi-driver-nfs
kubectl delete sc nfs-csi
```

## Parameters

Support driver parameters.

```shell
sealos run docker.io/labring/csi-driver-nfs:v4.4.0 \
-e server=192.168.1.10 \
-e share=/nfs/share \
-e subDir=subdir1/ \
-e mountPermissions="0" \ 
-e onDelete=delete \
-e disableDefaultStorageClass=true
```
