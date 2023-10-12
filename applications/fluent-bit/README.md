# Fluent-bit

Fast and Lightweight Logs and Metrics processor for Linux, BSD, OSX and Windows.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/fluent-bit:v2.1.10
```

Get app status

```shell
$ helm -n fluent-bit ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n fluent-bit uninstall fluent-bit
```

## Configuration

Refer to fluent-bit values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/fluent-bit:v2.1.10 \
-e NAME=my-fluent-bit -e NAMESPACE=my-fluent-bit -e HELM_OPTS="--set kind=DaemonSet"
```
