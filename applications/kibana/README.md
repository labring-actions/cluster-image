# Kibana

Your window into the Elastic Stack.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/kibana:v8.5.1
```

Get app status

```shell
$ helm -n elastic-system ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n elastic-system uninstall kibana
```

## Configuration

Refer to kibana values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `sealos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/kibana:v8.5.1 \
-e NAME=my-kibana -e NAMESPACE=my-kibana -e HELM_OPTS="--set service.type=NodePort"
```
