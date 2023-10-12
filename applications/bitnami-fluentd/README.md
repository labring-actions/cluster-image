# Bitnami fluentd

Fluentd collects events from various data sources and writes them to files, RDBMS, NoSQL, IaaS, SaaS, Hadoop and so on.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/bitnami-fluentd:v1.16.2 
```

Get app status

```shell
$ helm -n fluentd ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n fluentd uninstall fluentd
```

## Configuration

Refer to bitnami fluentd values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/bitnami-fluentd:v1.16.2  \
-e NAME=my-fluentd -e NAMESPACE=my-fluentd -e HELM_OPTS="--set aggregator.port=24444"
```
