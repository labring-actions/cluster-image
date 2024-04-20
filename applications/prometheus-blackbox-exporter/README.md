# Prometheus-blackbox-exporter

[Prometheus-blackbox-exporter](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-blackbox-exporter)，prometheus exporter for blackbox testing.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x

## Install the app

```shell
sealos run docker.io/labring/prometheus-blackbox-exporter:v0.24.0
```

Get app status

```shell
$ helm -n exporter ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n exporter uninstall prometheus-blackbox-exporter
```

## Configuration

Refer to prometheus-blackbox-exporter `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `sealos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/prometheus-blackbox-exporter:v0.24.0 -e HELM_OPTS="--set service.type=ClusterIP"
```
