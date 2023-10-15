# Openebs      

This openebs application only enabled [localpv-hostpath](https://openebs.io/docs/user-guides/localpv-hostpath).

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- Helm 3.x.x

## Installing the app

```shell
$ sealos run docker.io/labring/openebs:v3.8.0
```

Get storageclass

```
$ kubectl get sc
```

## Uninstalling the app

```shell
$ helm -n openebs uninstall openebs
```

## Configuration

Refer to openebs`values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `sealos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/openebs:v3.8.0 \
-e NAME=myopenebs -e NAMESPACE=myopenebs -e HELM_OPTS=" \
--set ndm.enabled=false \
--set ndmOperator.enabled=false \
--set localprovisioner.deviceClass.enabled=false \
--set localprovisioner.hostpathClass.isDefaultClass=true \
"
```
