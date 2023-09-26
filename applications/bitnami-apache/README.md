# Bitnami apache

Apache HTTP Server is an open-source HTTP server. The goal of this project is to provide a secure, efficient and extensible server that provides HTTP services in sync with the current HTTP standards.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/bitnami-apache:v2.4.57
```

Get app status

```shell
$ helm -n bitnami-apache ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n bitnami-apache uninstall bitnami-apache
```

## Configuration

Refer to bitnami apache values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/bitnami-apache:v2.4.57 \
-e NAME=my-bitnami-apache -e NAMESPACE=my-bitnami-apache -e HELM_OPTS="--set service.type=NodePort"
```
