# operator-lifecycle-manager

[operator-lifecycle-manager](https://github.com/operator-framework/operator-lifecycle-manager) is a management framework for extending Kubernetes with Operators.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x

## Install the app

```shell
sealos run docker.io/labring/operator-lifecycle-manager:v0.26.0
```

Get app status

```shell
$ kubectl -n olm get pods
```
