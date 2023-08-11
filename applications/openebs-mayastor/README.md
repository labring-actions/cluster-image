## Overview

**Mayastor** is a performance optimised "Container Attached Storage" (CAS) solution of the CNCF project [**OpenEBS**](https://openebs.io/). The goal of OpenEBS is to extend Kubernetes with a declarative data plane, providing flexible persistent storage for stateful applications.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- The minimum supported worker node count is three nodes. 
- Disks must be unpartitioned, unformatted, and used exclusively by the DiskPool.
- The minimum capacity of the disks should be 10 GB.

## Install

```shell
sealos run docker.io/labring/openebs-mayastor:v2.3.0
```

Custome config

```shell
sealos run docker.io/labring/openebs-mayastor:v2.3.0 -e HELM_OPTS=" \
--set=etcd.persistence.storageClass=manual \
--set=loki-stack.loki.persistence.storageClassName=manual"
```

Get pods status

```shell
root@node33:~# kubectl -n mayastor get pods
NAME                                          READY   STATUS    RESTARTS   AGE
mayastor-agent-core-cc9694cf8-h2q62           2/2     Running   0          7m34s
mayastor-agent-ha-node-9bv4g                  1/1     Running   0          7m34s
mayastor-agent-ha-node-jk995                  1/1     Running   0          7m34s
mayastor-agent-ha-node-w6qm5                  1/1     Running   0          7m34s
mayastor-api-rest-57bbd85f8-wbt56             1/1     Running   0          7m34s
mayastor-csi-controller-7785f864c6-xtlxn      5/5     Running   0          7m34s
mayastor-csi-node-2s6hz                       2/2     Running   0          7m34s
mayastor-csi-node-dt286                       2/2     Running   0          7m34s
mayastor-csi-node-qjpdq                       2/2     Running   0          7m34s
mayastor-etcd-0                               1/1     Running   0          7m34s
mayastor-etcd-1                               1/1     Running   0          7m34s
mayastor-etcd-2                               1/1     Running   0          7m34s
mayastor-io-engine-kj2tq                      2/2     Running   0          7m34s
mayastor-io-engine-w2x64                      2/2     Running   0          7m34s
mayastor-io-engine-zl7n7                      2/2     Running   0          7m34s
mayastor-loki-0                               1/1     Running   0          7m34s
mayastor-obs-callhome-78c94896d9-q7rrx        2/2     Running   0          7m34s
mayastor-operator-diskpool-667845865f-tqmbd   1/1     Running   0          7m34s
mayastor-promtail-crq4w                       1/1     Running   0          7m34s
mayastor-promtail-q4zmg                       1/1     Running   0          7m34s
mayastor-promtail-scsbp                       1/1     Running   0          7m34s
```

Get storageclass

```shell
root@node33:~# kubectl get sc
NAME                      PROVISIONER               RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
mayastor-single-replica   io.openebs.csi-mayastor   Delete          Immediate              false                  7m52s
```

## uninstall

```shell
helm -n mayastor uninstall mayastor
```
