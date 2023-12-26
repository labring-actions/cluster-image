# Istio

Connect, secure, control, and observe services.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x

## Install the app

```shell
sealos run docker.io/labring/istio:v1.20.1
```

Get app status

```shell
$ kubectl -n istio-system get pods
```

## Uninstalling the app

To completely uninstall Istio from a cluster, run the following command:

```bash
$ istioctl uninstall --purge
$ kubectl delete namespace istio-system
```

## Configuration

Refer to istioctl options  for the full run-down on defaults, For example:

```shell
$ sealos run docker.io/labring/istio:v1.20.1 -e ISTIOCTL_OPTS="--set profile=demo -y"
```
