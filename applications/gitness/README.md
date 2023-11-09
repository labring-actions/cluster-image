# Gitness

[Gitness](https://github.com/harness/gitness) is an open source development platform packed with the power of code hosting and automated DevOps pipelines.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x
- PV provisioner support in the underlying infrastructure

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/gitness:v3.0.0
```

Get app status

```shell
$ helm -n gitness ls
```

## Accessing the gigness UI

Default username/password: `admin/gitness`

```
http://<node-ip>:<node-port>
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n gitness uninstall gitness
```

## Configuration

Refer to gitness values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/gitness:v3.0.0 \
-e NAME=my-gitness -e NAMESPACE=my-gitness -e HELM_OPTS="--set service.type=NodePort"
