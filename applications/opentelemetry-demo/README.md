## opentelemetry-demo

This [opentelemetry-demo](https://github.com/open-telemetry/opentelemetry-demo) repository contains the OpenTelemetry Astronomy Shop, a microservice-based distributed system intended to illustrate the implementation of OpenTelemetry in a near real-world environment.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos v4.x.x
- helm v3.x.x

## Get started

Install with sealos run

```shell
sealos run docker.io/labring/opentelemetry-demo:v1.5.0
```

## Uninstall

```shell
helm -n opentelemetry-demo uninstall opentelemetry-demo
```

## Custome configuraton

Specify each parameter using the `--set key=value[,key=value]` argument to `-e HELM_OPTS`. For example:

```bash
sealos run docker.io/labring/opentelemetry-demo:v1.5.0 \
  -e HELM_OPTS="--set default.image.tag=<different tag from app version>"
```
