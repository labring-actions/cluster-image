# stakater-reloader

[stakater-reloader](https://github.com/stakater/Reloader)  is a Kubernetes controller to watch changes in ConfigMap and Secrets and do rolling upgrades on Pods with their associated Deployment, StatefulSet, DaemonSet and DeploymentConfig.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x

## Install the app

```shell
sealos run docker.io/labring/stakater-reloader:v1.0.80
```

Get app status

```shell
$ helm -n reloader ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n reloader uninstall stakater-reloader
```

## Configuration

Refer to stakater-reloader `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/stakater-reloader:v1.0.80 -e HELM_OPTS="--set reloader.watchGlobally=true"
```
