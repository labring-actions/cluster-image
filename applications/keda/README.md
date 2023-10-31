## KEDA

[KEDA](https://github.com/kedacore/keda) is a Kubernetes-based Event Driven Autoscaling component. It provides event driven scale for any container running in Kubernetes.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos v4.x.x
- helm v3.x.x

## Get started

Install with sealos run

```shell
sealos run docker.io/labring/keda:v2.12.0
```

## Uninstall

```shell
helm -n keda uninstall keda
```

## Custome configuraton

Specify each parameter using the `--set key=value[,key=value]` argument to `-e HELM_OPTS`. For example:

```bash
sealos run docker.io/labring/keda:v2.12.0 \
  -e HELM_OPTS="--set image.keda.tag=<different tag from app version>"
```
