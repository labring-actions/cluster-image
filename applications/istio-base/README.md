# Istio/base

Connect, secure, control, and observe services.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x

## Install the app

```shell
sealos run docker.io/labring/istio-base:v1.22.1
```

Get app status

```shell
$ kubectl get crd | grep istio.io
```

## Uninstalling the app

To completely uninstall Istio/base from a cluster, run the following command:

```bash
$ helm uninstall istio-base -n istio-system
$ kubectl delete namespace istio-system
```
