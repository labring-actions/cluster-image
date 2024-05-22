# SeaweedFS CSI Driver

[SeaweedFS CSI Driver](https://github.com/seaweedfs/seaweedfs-csi-driver).

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x

## Install the app

```shell
sealos run docker.io/labring/seaweedfs-csi-driver:latest
```

Get app status

```shell
$ helm -n seaweedfs ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n seaweedfs uninstall seaweedfs-csi-driver
```

## Configuration

Refer to  `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/seaweedfs-csi-driver:latest -e HELM_OPTS=" \
--set seaweedfsFiler=seaweedfs-filer:8888 \
--set isDefaultStorageClass=true"}
```
