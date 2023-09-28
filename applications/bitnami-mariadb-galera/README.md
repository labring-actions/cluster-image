# Bitnami MariaDB Galera

MariaDB Galera is a multi-primary database cluster solution for synchronous replication and high availability.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x
- PV provisioner support in the underlying infrastructure

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/bitnami-mariadb-galera:v11.0.3
```

Get app status

```shell
$ helm -n bitnami-mariadb-galera ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n bitnami-mariadb-galera uninstall bitnami-mariadb-galera
```

## Configuration

Refer to bitnami-mariadb-galera values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/bitnami-mariadb-galera:v11.0.3 \
-e NAME=my-bitnami-mariadb-galera -e NAMESPACE=my-bitnami-mariadb-galera -e HELM_OPTS="--set service.type=NodePort"
```
