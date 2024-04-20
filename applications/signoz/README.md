# signoz

[Signoz(https://github.com/SigNoz/signoz)  is a single tool for all your observability needs - APM, logs, metrics, exceptions, alerts, and dashboards powered by a powerful query builder.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x
- PV provisioner support in the underlying infrastructure

## Install the app

```shell
sealos run docker.io/labring/signoz:v0.39.1
```

Get app status

```shell
$ helm -n platform ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n platform uninstall signoz
```

## Configuration

Refer to `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/signoz:v0.39.1  -e HELM_OPTS="--set frontend.service.type=NodePort"
```
