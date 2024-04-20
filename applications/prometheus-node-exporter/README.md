# Prometheus-node-exporter

[Prometheus node exporter](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-node-exporter) for hardware and OS metrics exposed by *NIX kernels, written in Go with pluggable metric collectors.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x

## Install the app

```shell
sealos run docker.io/labring/prometheus-node-exporter:v1.7.0
```

Get app status

```shell
$ helm -n exporter ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n exporter uninstall prometheus-node-exporter
```

## Configuration

Refer to prometheus-node-exporter `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/prometheus-node-exporter:v1.7.0 -e HELM_OPTS="--set service.type=ClusterIP"
```
