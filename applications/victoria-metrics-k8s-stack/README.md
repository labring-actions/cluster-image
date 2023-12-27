# victoria-metrics-k8s-stack

[Victoria-metrics-k8s-stack](https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-metrics-k8s-stack) is kubernetes monitoring on VictoriaMetrics stack. Includes VictoriaMetrics Operator, Grafana dashboards, ServiceScrapes and VMRules.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x
- PV support on underlying infrastructure.

## Install the app

```shell
$ sealos run docker.io/labring/victoria-metrics-k8s-stack:v1.96.0
```

Get app status

```shell
$ helm -n vm ls
```

## Access grafana

Get `admin` user password

```
kubectl -n vm get secrets victoria-metrics-k8s-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

Access grafana

```
http://<node-ip>:<node-port>
```

## Uninstalling the app

```bash
$ helm -n vm uninstall victoria-metrics-k8s-stack
```

## Configuration

Refer to victoria-metrics-k8s-stack `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/victoria-metrics-k8s-stack:v1.96.0 -e HELM_OPTS="--set grafana.service.type=NodePort"
```
