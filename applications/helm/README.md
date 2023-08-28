# Helm

The Kubernetes Package Manager.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x

## Installing the app

```shell
$ sealos run docker.io/labring/helm:v3.12.3
```

helm will be installed on the first master node.

```shell
$ which helm
/usr/bin/helm
```

## Uninstalling the app

```shell
rm -rf /usr/bin/helm
```
