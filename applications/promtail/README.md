# Promtail

A lightweight client for Grafana Loki log collection server for Gophers.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- Helm 3.x.x

## Installing the app

```shell
$ sealos run docker.io/labring/promtail:v2.8.3
```

Get pods status

```shell
root@ubuntu:~# kubectl -n loki get pods
NAME                                          READY   STATUS    RESTARTS   AGE
promtail-786mg                                1/1     Running   0          58m
```

## Uninstalling the app

```shell
helm -n loki uninstall promtail
```

## Configuration

Refer to promtail `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/promtail:v2.8.3 \
-e NAME=mypromtail -e NAMESPACE=mypromtail -e HELM_OPTS="--set config.clients.url[0]=http://loki-gateway/loki/api/v1/push"
```
