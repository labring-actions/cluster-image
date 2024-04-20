# Kubean

[kubean](https://github.com/kubean-io/kubean)  is a portable, event-driven, runtime for building distributed applications across cloud and edge.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x

## Install the app

```shell
sealos run docker.io/labring/kubean:v0.13.3
```

Get app status

```shell
$ helm -n kubean-system ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n kubean-system uninstall kubean
```

## Configuration

Refer to values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/kubean:v0.13.3 -e HELM_OPTS="--set kubeanOperator.replicaCount=1"
```
