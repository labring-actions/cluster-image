# Prometheus

[Prometheus](https://prometheus.io/), a [Cloud Native Computing Foundation](https://cncf.io/) project, is a systems and service monitoring system. It collects metrics from configured targets at given intervals, evaluates rule expressions, displays the results, and can trigger alerts if some condition is observed to be true.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x
- PV provisioner support in the underlying infrastructure 

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/prometheus:v2.47.0
```

Get app status

```shell
$ helm -n prometheus ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n prometheus uninstall prometheus
```

## Configuration

Refer to prometheus values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/prometheus:v2.47.0  \
-e NAME=my-prometheus -e NAMESPACE=my-prometheus -e HELM_OPTS="--set server.service.type=NodePort"
```
