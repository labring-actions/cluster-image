# ElasticSearch

Free and Open, Distributed, RESTful Search Engine.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x
- PV provisioner support in the underlying infrastructure

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/elasticsearch:v8.5.1
```

Get app status

```shell
$ helm -n elastic-system ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n elastic-system uninstall elasticsearch
```

## Configuration

Refer to elasticsearch values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/elasticsearch:v8.5.1 \
-e NAME=my-elasticsearch -e NAMESPACE=my-elasticsearch -e HELM_OPTS="--set secret.password=elastic --set antiAffinity=soft --set service.type=NodePort"
```
