# Bitnami PostgreSQL

PostgreSQL (Postgres) is an open source object-relational database known for reliability and data integrity. ACID-compliant, it supports foreign keys, joins, views, triggers and stored procedures.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x
- PV provisioner support in the underlying infrastructure

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/bitnami-postgresql:v15.4.0
```

Get app status

```shell
$ helm -n bitnami-postgresql ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n bitnami-postgresql uninstall bitnami-postgresql
```

## Configuration

Refer to bitnami postgresql [values.yaml](https://github.com/bitnami/charts/blob/main/bitnami/postgresql/values.yaml) for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `sealos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/bitnami-postgresql:v15.4.0 \
-e NAME=my-bitnami-postgresql -e NAMESPACE=my-bitnami-postgresql -e HELM_OPTS="--set primary.service.type=NodePort"
```
