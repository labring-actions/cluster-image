# OceanBase Dashboard

[ob-operator](https://github.com/oceanbase/ob-operator) is a Kubernetes operator that simplifies the deployment and management of OceanBase cluster and related resources on Kubernetes.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos
- Helm

## Install the app

```shell
sealos run docker.io/labring/ob-operator:v2.2.1
```

Get app status

```shell
$ helm -n oceanbase-system ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n oceanbase-system uninstall ob-operator
```

## Configuration

Refer to  `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/ob-operator:v2.2.1 -e HELM_OPTS="--set key=value"
```
