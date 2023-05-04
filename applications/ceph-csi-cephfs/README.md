# ceph-csi-cephfs

CSI driver for Ceph

## Prerequisites

- Kubernetes (depends on the app requirements)
- sealos v4.x.x

## Installing the app

Get ceph cluster info

```bash
$ ceph mon dump
```

Get admin user info

```bash
$ ceph auth get client.admin
```

Create osd pool

```bash
$ ceph osd pool create cephfs_data 64 64
$ ceph osd pool create cephfs_metadata 64 64
$ ceph fs new cephfs cephfs_metadata cephfs_data
```

Create ceph-csi-rbd-config.yaml

```yaml
apiVersion: apps.sealos.io/v1beta1
kind: Config
metadata:
  name: ceph-csi-cephfs-config
spec:
  path: charts/ceph-csi-cephfs.values.yaml
  match: docker.io/labring/ceph-csi-cephfs:v3.8.0
  strategy: override
  data: |
    csiConfig:
      - clusterID: "ede7808e-bea4-11ed-859e-a91bb23768ed"
        monitors:
          - "192.168.12.10:6789"
          - "192.168.12.11:6789"
          - "192.168.12.12:6789"
    storageClass:
      create: true
      clusterID: "ede7808e-bea4-11ed-859e-a91bb23768ed"
      pool: "cephfs_data"
      fsName: "cephfs"
    secret:
      create: true
      adminID: "admin"
      adminKey: "AQAiIApk6jzXKBAAIzssAfXdgD2+K/E5d4T25w=="
```

To install the app with sealos run  command:

```bash
sealos run docker.io/labring/ceph-csi-cephfs:v3.8.0 --config-file ceph-csi-cephfs-config.yaml
```

These commands deploy kube-ovn with install.sh to the Kubernetes cluster，list app using:

```bash
kubectl -n ceph-csi-cephfs get pods
```

Get storageclass

```bash
$ kubectl get sc
NAME                   PROVISIONER           RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
csi-cephfs-sc          cephfs.csi.ceph.com   Delete          Immediate           true                   7m13s
csi-rbd-sc (default)   rbd.csi.ceph.com      Delete          Immediate           true                   24m
```

Run demo app and test pv bond

```bash
$ kubectl get pvc
NAME      STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS    AGE
nfs-pvc   Bound    pvc-e98502a3-64c6-462c-8080-f115d16c0d7a   5Gi        RWO            csi-cephfs-sc   92s

$ root@node34:~# kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM             STORAGECLASS    REASON   AGE
pvc-e98502a3-64c6-462c-8080-f115d16c0d7a   5Gi        RWO            Delete           Bound    default/nfs-pvc   csi-cephfs-sc            96s
```

## Custome configuraton

Custome  config,

```bash
sealos run registry.cn-shenzhen.aliyuncs.com/cnmirror/ceph-csi-cephfs:v3.8.0 \
--config-file ceph-csi-cephfs-config.yaml -e HELM_OPTS="--set provisioner.replicaCount=1"
```

## Uninstalling the app

To uninstall/delete the app:

```bash
sealos run docker.io/labring/ceph-csi-cephfs:v3.8.0 -e uninstall=true
```

The command removes all the resource associated with the installtion.
