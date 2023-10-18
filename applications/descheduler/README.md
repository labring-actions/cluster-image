# Descheduler

Descheduler for Kubernetes.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/descheduler:v0.28.0
```

Get app status

```shell
$ helm -n descheduler ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n descheduler uninstall descheduler
```

## Configuration

Refer to Official values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/descheduler:v0.28.0 \
-e NAME=my-descheduler -e NAMESPACE=my-descheduler -e HELM_OPTS="--set key=value"
```
