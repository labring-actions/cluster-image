# Fluxcd

[flux](https://github.com/fluxcd/flux2) is an open and extensible continuous delivery solution for Kubernetes. Powered by GitOps Toolkit.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x

## Install the app

```shell
sealos run docker.io/labring/fluxcd:v2.1.2
```

Get app status

```shell
$ kubectl -n flux-system get pods
```

## Uninstalling the app

Uninstall with flux command

```shell
$ flux uninstall -s
```

## Configuration

Refer to flux CLI for the full run-down on defaults.

Specify each parameter using the `flux install` argument to `seaos run -e FLUX_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/fluxcd:v2.1.2 -e NAMESAPCE=flux-systerm \
-e FLUX_OPTS="--components-extra=image-reflector-controller,image-automation-controller"
```
