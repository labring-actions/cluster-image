# OceanBase Cluster

[ob-operator](https://github.com/oceanbase/ob-operator) is a Kubernetes operator that simplifies the deployment and management of OceanBase cluster and related resources on Kubernetes.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos
- Helm
- PV provisioner support in the underlying infrastructure
- cert-manager

## Install the app

```shell
sealos run docker.io/labring/oceanbase-cluster:v4.2.1 -e HELM_OPTS="--set storageClass=openebs-hostpath"
```

Get app status

```shell
$ helm -n oceanbase ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n oceanbase uninstall oceanbase-cluster
```

## Configuration

Refer to  `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/oceanbase-cluster:v4.2.1 -e HELM_OPTS="--set storageClass=local-path"
```
