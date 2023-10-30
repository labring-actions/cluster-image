## opentelemetry-collector

The [OpenTelemetry Collector](https://github.com/open-telemetry/opentelemetry-collector) offers a vendor-agnostic implementation on how to receive, process and export telemetry data. 

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos v4.x.x
- helm v3.x.x

## Get started

Install with sealos run

```shell
sealos run docker.io/labring/opentelemetry-collector:v0.87.0
```

## Uninstall

```shell
helm -n opentelemetry-collector uninstall opentelemetry-collector
```

## Custome configuraton

Specify each parameter using the `--set key=value[,key=value]` argument to `-e HELM_OPTS`. For example:

```bash
sealos run docker.io/labring/opentelemetry-collector:v0.87.0 \
  -e HELM_OPTS="--set mode=daemonset"
```
