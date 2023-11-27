# TiDB-Operator

[TiDB operator](https://github.com/pingcap/tidb-operator)  creates and manages TiDB clusters running in Kubernetes.

This setup use [tidb-operator/examples/basic](https://github.com/pingcap/tidb-operator/tree/master/examples/basic)，and is for test or demo purpose only and **IS NOT** applicable for critical environment. 

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x
- PV provisioner support in the underlying infrastructure

## Install the app

```shell
sealos run docker.io/labring/tidb-operator:v1.5.1
```

Get app status

```shell
$ helm -n tidb-admin ls tidb-operator
$ kubectl -n tidb-cluster get pods
```

## Access TiDB dashboard

Get service nodeport

```bash
$ kubectl -n tidb-cluster get svc
```

Access dashboard with default user `root` and empty password.

```bash
http://<node-ip>:<node-port>
```

