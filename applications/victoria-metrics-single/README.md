# Victoria-metrics-single

[Victoria Metrics Single version](https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-metrics-single) - high-performance, cost-effective and scalable TSDB, long-term remote storage for Prometheus.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x
- PV support on underlying infrastructure

## Install the app

This will install victoria-metrics-single with helm:

```shell
$ sealos run docker.io/labring/victoria-metrics-single:v1.96.0
```

Get app status

```shell
$ helm -n vmsingle ls
```

## Configuration

Refer to victoria-metrics-single `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/victoria-metrics-single:v1.96.0 -e HELM_OPTS="--set server.service.type=NodePort"
```

## Uninstalling the app

Uninstall with helm command

```shell
$ helm -n vmsingle uninstall vmsingle
```
