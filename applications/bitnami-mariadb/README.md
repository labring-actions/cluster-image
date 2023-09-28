# Bitnami MariaDB

MariaDB is an open source, community-developed SQL database server that is widely in use around the world due to its enterprise features, flexibility, and collaboration with leading tech firms.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x
- PV provisioner support in the underlying infrastructure

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/bitnami-mariadb:v11.0.3
```

Get app status

```shell
$ helm -n bitnami-mariadb ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n bitnami-mariadb uninstall bitnami-mariadb
```

## Configuration

Refer to bitnami-mariadb values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/bitnami-mariadb:v11.0.3 \
-e NAME=my-bitnami-mariadb -e NAMESPACE=my-bitnami-mariadb -e HELM_OPTS="--set primary.service.type=NodePort"
```
