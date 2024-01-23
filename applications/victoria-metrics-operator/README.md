# VictoriaMetrics operator

[VictoriaMetrics operator](https://github.com/VictoriaMetrics/operator) - Kubernetes operator for Victoria Metrics.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x
- PV support on underlying infrastructure

## Install the app

This will install victoria-metrics-single with helm:

```shell
$ sealos run docker.io/labring/victoria-metrics-operator:v0.39.3
```

Get app status

```shell
$ helm -n vm ls
```

## Configuration

### Config operator

Refer to victoria-metrics-operator `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/victoria-metrics-operator:v0.39.3 -e HELM_OPTS="--set server.service.type=NodePort"
```

### Deploy components

Get mount path which is `default-xxxxxx`.

```
container_name=$(sealos ps -f ancestor=victoria-metrics-operator --notruncate --format "{{.ContainerName}}")
cd /var/lib/sealos/data/default/applications/${container_name}/workdir
ls manifests/examples
```

change to that path and apply [examples yaml file](https://github.com/VictoriaMetrics/operator/tree/master/config/examples).

```
kubectl apply -f manifests/examples/xxx.yaml
```

## Uninstalling the app

Firstly, delete all deployed components，then uninstall operator with helm command

```shell
$ helm -n vm uninstall victoria-metrics-operator
```
