# Dapr-dashboard

[Dapr-dashboard](https://github.com/dapr/dashboard)  is General purpose dashboard for Dapr.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x

## Install the app

```shell
sealos run docker.io/labring/dapr-dashboard:v0.14.0
```

Get app status

```shell
$ helm -n dapr-system ls
```

## Access dashboard

```bash
http://<node-ip>:<node-port>
```

## Uninstalling the app

Uninstall with helm command

```shell
$ helm -n dapr-system uninstall dapr-dashboard
```

## Configuration

Refer to dapr-dashboard `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/dapr-dashboard:v0.14.0  -e HELM_OPTS="--set serviceType=NodePort"
```
