# ceph-csi-rbd

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
$ cephadm shell
$ ceph osd pool create replicapool 64 64
$ rbd pool init replicapool
```

Create ceph-csi-rbd-config.yaml

```yaml
apiVersion: apps.sealos.io/v1beta1
kind: Config
metadata:
  name: ceph-csi-rbd-config
spec:
  path: charts/ceph-csi-rbd.values.yaml
  match: docker.io/labring/ceph-csi-rbd:v3.8.0
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
      annotations:
        storageclass.kubernetes.io/is-default-class: "true"
      clusterID: "ede7808e-bea4-11ed-859e-a91bb23768ed"
      pool: "replicapool"
    secret:
      create: true
      userID: "admin"
      userKey: "AQAiIApk6jzXKBAAIzssAfXdgD2+K/E5d4T25w=="
```

To install the app with sealos run  command:

```bash
sealos run docker.io/labring/ceph-csi-rbd:v3.8.0 --config-file ceph-csi-rbd-config.yaml
```

These commands deploy kube-ovn with install.sh to the Kubernetes cluster，list app using:

```bash
kubectl -n ceph-csi-rbd get pods
```

Get storageclass

```bash
$ kubectl get sc
NAME                   PROVISIONER        RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
csi-rbd-sc (default)   rbd.csi.ceph.com   Delete          Immediate           true                   5m43s
```

Run demo app and test pv bond

```
$ sealos run hub.sealos.cn/labring/tomcat:v10.5.14

$ kubectl -n tomcat get pvc
NAME     STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
tomcat   Bound    pvc-1041cb55-9909-436f-96f5-003cc90ef8f8   8Gi        RWO            csi-rbd-sc     4m54s

$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM           STORAGECLASS   REASON   AGE
pvc-1041cb55-9909-436f-96f5-003cc90ef8f8   8Gi        RWO            Delete           Bound    tomcat/tomcat   csi-rbd-sc              4m57s
```

## Custome configuraton

Custome  config,

```bash
sealos run docker.io/labring/ceph-csi-rbd:v3.8.0 \
--config-file ceph-csi-rbd-config.yaml -e HELM_OPTS="--set provisioner.replicaCount=1"
```

## Uninstalling the app

To uninstall/delete the app:

```bash
sealos run docker.io/labring/ceph-csi-rbd:v3.8.0 -e uninstall=true
```

The command removes all the resource associated with the installtion.
