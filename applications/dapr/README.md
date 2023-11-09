# Dapr

[Dapr](https://github.com/dapr/dapr)  is a portable, event-driven, runtime for building distributed applications across cloud and edge.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x

## Install the app

```shell
sealos run docker.io/labring/dapr:v1.12.0
```

Get app status

```shell
$ helm -n dapr-system ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n dapr-system uninstall dapr
```

## Configuration

Refer to dapr`values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/dapr:v1.12.0  -e HELM_OPTS="--set global.ha.enabled=true"
```
