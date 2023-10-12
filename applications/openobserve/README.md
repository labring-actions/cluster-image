# openobserve

OpenObserve is a cloud native observability platform built specifically for logs, metrics, traces and analytics designed to work at petabyte scale.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x
- PV provisioner support in the underlying infrastructure

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/openobserve:v0.6.4
```

Get app status

```shell
$ helm -n openobserve ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n openobserve uninstall openobserve
```

## Configuration

Refer to openobserve values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/openobserve:v0.6.4  \
-e NAME=my-openobserve -e NAMESPACE=my-openobserve -e HELM_OPTS="--set service.type=NodePort \
--set minio.enabled=true \"
```
