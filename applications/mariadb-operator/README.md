## mariadb-operator

 Run and operate MariaDB in a cloud native way.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- default storageclass

## Install

```shell
sealos run docker.io/labring/mariadb-operator:v0.0.20
```

Custome values
```shell
sealos run docker.io/labring/mariadb-operator:v0.0.20 -e HELM_OPTS="--set ha.enabled=true"
```

## Uninstall

```shell
$ helm -n mariadb-operator uninstall mariadb-operator
```
