# gatekeeper

[Gatekeeper](https://github.com/open-policy-agent/gatekeeper) - Policy Controller for Kubernetes.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/gatekeeper:v3.13.3 
```

Get app status

```shell
$ helm -n gatekeeper-system ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n gatekeeper-system uninstall gatekeeper
```

## Configuration

Refer to gatekeeper values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/gatekeeper:v3.13.3 \
-e NAME=my-gatekeeper -e NAMESPACE=my-gatekeeper -e HELM_OPTS="--set rbac.create=true"
