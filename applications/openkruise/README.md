# openkruise

Automated management of large-scale applications on Kubernetes.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/openkruise:v1.5.0 
```

Get app status

```shell
$ helm -n kruise-system ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n kruise-system uninstall kruise
```

## Configuration

Refer to openkruise values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/openkruise:v1.5.0 \
-e NAME=my-kruise -e NAMESPACE=my-kruise -e HELM_OPTS="--set installation.namespace=my-kruise"
