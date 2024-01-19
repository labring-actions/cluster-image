# milvus

[milvus](https://github.com/milvus-io/milvus)  is a cloud-native vector database, storage for next generation AI applications.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x
- PV provisioner support in the underlying infrastructure

## Install the app

This will install Milvus Standalone with helm:

```shell
sealos run docker.io/labring/milvus:v2.3.5
```

Get app status

```shell
$ helm -n milvus ls
```

## Uninstalling the app

Uninstall with helm command

```shell
$ helm -n milvus uninstall milvus
```

## Configuration

Refer to dapr `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/milvus:v2.3.5 -e HELM_OPTS=" \
--set cluster.enabled=false \
--set etcd.replicaCount=1 \
--set minio.mode=standalone \
--set pulsar.enabled=false"
```
