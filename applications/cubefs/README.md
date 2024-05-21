# cubefs

[CubeFS](https://github.com/cubefs/cubefs) is an open-source cloud-native file storage system, hosted by the [Cloud Native Computing Foundation](https://cncf.io/) (CNCF) as an [incubating](https://www.cncf.io/projects/) project.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos
- Helm
- Kubernetes cluster with at least 3 nodes
- label the machine with its own label
- Mount Data Disk

Refer to cubefs official documentation：https://www.cubefs.io/docs/master/deploy/k8s.html

Label example:

```bash
# Master node, at least three, it is recommended to have an odd number
kubectl label nodes node01 node02 node03 component.cubefs.io/master=enabled
# MetaNode metadata node, at least 3, odd or even
kubectl label nodes node01 node02 node03 component.cubefs.io/metanode=enabled
# Dataode data node, at least 3, odd or even
kubectl label nodes node01 node02 node03 component.cubefs.io/datanode=enabled
# ObjectNode object storage node, can be marked as needed, if you don't need object storage function, you can also not deploy this component
kubectl label nodes node01 node02 node03 component.cubefs.io/objectnode=enabled
# csi, all nodes
kubectl label nodes --all component.cubefs.io/csi=enabled
```

## Install the app

```shell
sealos run docker.io/labring/cubefs:v3.3.0
```

Get app status

```shell
$ helm -n cubefs ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n cubefs uninstall cubefs
```

## Configuration

Refer to  `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/cubefs:v3.3.0 -e HELM_OPTS=" \
--set image.server=cubefs/cfs-server:v3.3.0 \
--set image.client=cubefs/cfs-client:v3.3.0 \
--set metanode.total_mem=4294967296 \
--set metanode.resources.enabled=false"
```
