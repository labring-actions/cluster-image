# logging-operator

The [Logging operator](https://github.com/kube-logging/logging-operator) solves your logging-related problems in Kubernetes environments by automating the deployment and configuration of a Kubernetes logging pipeline.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x
- PV provisioner support in the underlying infrastructure

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/logging-operator:v4.4.0
```

Get app status

```shell
$ helm -n logging ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n logging uninstall logging-operator
```

## Configuration

Refer to logging-operator values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/logging-operator:v4.4.0 \
-e NAME=my-logging-operator -e NAMESPACE=my-logging-operator -e HELM_OPTS="--set logging.enabled=true"
```
