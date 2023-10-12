# Bitnami Elasticsearch Stack

Elasticsearch is a distributed search and analytics engine. It is used for web search, log monitoring, and real-time analytics. Ideal for Big Data applications.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x
- PV provisioner support in the underlying infrastructure

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/bitnami-elasticsearch:v8.10.0
```

Get app status

```shell
$ helm -n elasticsearch ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n elasticsearch uninstall elasticsearch
```

## Configuration

Refer to bitnami-elasticsearch values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/bitnami-elasticsearch:v8.10.0 \
-e NAME=my-elasticsearch -e NAMESPACE=my-elasticsearch -e HELM_OPTS="--set service.type=NodePort"
```
