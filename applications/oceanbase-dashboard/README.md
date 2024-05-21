# OceanBase Dashboard

OceanBase Kubernetes Dashboard, a pioneering tool designed to enhance your experience with managing and monitoring OceanBase clusters on Kubernetes. 

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos
- Helm

## Install the app

```shell
sealos run docker.io/labring/oceanbase-dashboard:v0.2.1
```

Get app status

```shell
$ helm -n oceanbase ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n oceanbase uninstall oceanbase-dashboard
```

## Configuration

Refer to  `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/oceanbase-dashboard:v0.2.1 -e HELM_OPTS="--set service.type=NodePort"
```
