## opentelemetry-operator

The [OpenTelemetry Operator](https://github.com/open-telemetry/opentelemetry-operator) is a Kubernetes Operator for OpenTelemetry Collector.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos v4.x.x
- helm v3.x.x
- CertManager

## Get started

Install with sealos run

```shell
sealos run docker.io/labring/opentelemetry-operator:v0.87.0
```

## Uninstall

```shell
helm -n opentelemetry-operator-system uninstall opentelemetry-operator
```

## Custome configuraton

Specify each parameter using the `--set key=value[,key=value]` argument to `-e HELM_OPTS`. For example:

```bash
sealos run docker.io/labring/opentelemetry-operator:v0.87.0 \
  -e HELM_OPTS="--set manager.image.tag=<different tag from app version>"
```
