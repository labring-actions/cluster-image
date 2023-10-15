# Vector

A high-performance observability data pipeline.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/vector:v0.33.0-distroless-libc
```

Get app status

```shell
$ helm -n vector ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n vector uninstall vector
```

## Configuration

Refer to vector values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `sealos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/vector:v0.33.0-distroless-libc \
-e NAME=my-vector -e NAMESPACE=my-vector -e HELM_OPTS="--set role=Agent"
```
