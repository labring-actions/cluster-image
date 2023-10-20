# portainer

[Portainer]https://github.com/portainer/portainer)  is a lightweight service delivery platform for containerized applications that can be used to manage Docker, Swarm, Kubernetes and ACI environments.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/portainer:ce-latest-ee-2.19.1
```

Get app status

```shell
$ helm -n portainer ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n portainer uninstall portainer
```

## Configuration

Refer to portainer values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/portainer:ce-latest-ee-2.19.1 \
-e NAME=my-portainer -e NAMESPACE=my-portainer -e HELM_OPTS="--set tls.force=true"
