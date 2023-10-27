# kubegems

[KubeGems](https://kubegems.io/) is an open source, enterprise-class multi-tenant container cloud platform.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x
- PV provisioner with defalut StorageClass in the underlying infrastructure

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/kubegems:v1.23.8
```

Get app status

```shell
$ helm -n kubegems ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n kubegems uninstall kubegems 
helm -n kubegems-installer uninstall kubegems-installer
kubectl -n kubegems delete pvc --all
```

## Configuration

Refer to kubegems values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/kubegems:v1.23.8 \
-e NAME=my-kubegems -e NAMESPACE=my-kubegems -e HELM_OPTS="--set ingress.enable=false \
--set dashboard.service.type=NodePort"
```
