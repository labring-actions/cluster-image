# tianji

[Tianji](https://github.com/msgbyte/tianji): Insight into everything, Website Analytics + Uptime Monitor + Server Status. not only another GA alternatives.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos
- Helm
- PV provisioner support in the underlying infrastructure

## Install the app

```shell
sealos run docker.io/labring/tianji:v1.11.2
```

Get app status

```shell
$ helm -n tianji ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n tianji uninstall tianji
```

## Configuration

Refer to  `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`.

For example:

```shell
$ sealos run docker.io/labring/tianji:v1.11.2 -e HELM_OPTS="--set service.type=NodePort"
```
