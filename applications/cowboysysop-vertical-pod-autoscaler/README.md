# cowboysysop-vertical-pod-autoscaler

[Vertical Pod Autoscaler](https://github.com/kubernetes/autoscaler) is a set of components that automatically adjust the amount of CPU and memory requested by pods running in the Kubernetes Cluster.

**DISCLAIMER**: This is an unofficial chart not supported by Vertical Pod Autoscaler authors.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x
- metrics-server

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/cowboysysop-vertical-pod-autoscaler:v0.14.0
```

Get app status

```shell
$ kubectl -n cowboysysop-vertical-pod-autoscaler get pods
```

## Uninstalling the app

```shell
$ helm -n cowboysysop-vertical-pod-autoscaler uninstall cowboysysop-vertical-pod-autoscaler
```

## Configuration

Specify each parameter using the `--set key=value[,key=value]` argument to `sealos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/cowboysysop-vertical-pod-autoscaler:v0.14.0 \
-e NAME=my-cowboysysop-vertical-pod-autoscaler -e NAMESPACE=my-cowboysysop-vertical-pod-autoscaler \
-e HELM_OPTS="--set admissionController.enabled=true"
```
