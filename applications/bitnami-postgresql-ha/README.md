# Bitnami PostgreSQL-ha

This PostgreSQL cluster solution includes the PostgreSQL replication manager, an open-source tool for managing replication and failover on PostgreSQL clusters.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x
- PV provisioner support in the underlying infrastructure

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/bitnami-postgresql-ha:v15.4.0
```

Get app status

```shell
$ helm -n bitnami-postgresql-ha ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n bitnami-postgresql-ha uninstall bitnami-postgresql-ha
```

## Configuration

Refer to bitnami postgresql-ha [values.yaml](https://github.com/bitnami/charts/blob/main/bitnami/postgresql-ha/values.yaml) for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/bitnami-postgresql-ha:v15.4.0 \
-e NAME=my-bitnami-postgresql-ha -e NAMESPACE=my-bitnami-postgresql-ha -e HELM_OPTS="--set service.type=NodePort"
```
