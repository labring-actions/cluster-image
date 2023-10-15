# Bitnami kafka

Apache Kafka is a distributed streaming platform designed to build real-time pipelines and can be used as a message broker or as a replacement for a log aggregation solution for big data applications..

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x
- PV provisioner support in the underlying infrastructure

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/bitnami-kafka:v3.5.1
```

Get app status

```shell
$ helm -n kafka ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n kafka uninstall kafka
```

## Configuration

Refer to kafka-ui values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `sealos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/bitnami-kafka:v3.5.1 \
-e NAME=my-kafka -e NAMESPACE=my-kafka -e HELM_OPTS="--set sasl.client.passwords=password1"
```
