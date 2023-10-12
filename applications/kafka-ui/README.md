# Kafka-ui

[Kafka-ui](https://github.com/provectus/kafka-ui) is Open-Source Web UI for Apache Kafka Management.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/kafka-ui:v0.7.1
```

Get app status

```shell
$ helm -n kafka-ui ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n kafka-ui uninstall kafka-ui
```

## Configuration

Refer to kafka-ui values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/kafka-ui:v0.7.1 \
-e NAME=my-kafka-ui -e NAMESPACE=my-kafka-ui -e HELM_OPTS="--set service.type=NodePort"
```
