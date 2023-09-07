# Helm-dashboard

The missing UI for Helm - visualize your releases.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/helm-dashboard:v1.3.3
```

Get app status

```shell
$ helm -n helm-dashboard ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n helm-dashboard uninstall helm-dashboard
```

## Configuration

Refer to helm-dashboard [values.yaml](https://github.com/komodorio/helm-dashboard/tree/main/charts/helm-dashboard) for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/helm-dashboard:v1.3.3 \
-e NAME=my-helm-dashboard -e NAMESPACE=my-helm-dashboard -e HELM_OPTS="--set service.type=LoadBalancer"
```

