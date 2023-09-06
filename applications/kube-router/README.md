# kube-router

Kube-router, a turnkey solution for Kubernetes networking.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- CNI-plugins

## Installing the app

Maybe CNI plugin is required.
```
$ sealos run docker.io/labring/cni-plugins:v1.3.0
```

Run app with sealos

```shell
$ sealos run docker.io/labring/kube-router:v1.6.0
```
