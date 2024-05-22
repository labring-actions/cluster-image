# seaweedfs

[SeaweedFS](https://github.com/seaweedfs/seaweedfs) is a fast distributed storage system for blobs, objects, files, and data lake, for billions of files! Blob store has O(1) disk seek, cloud tiering. Filer supports Cloud Drive, cross-DC active-active replication, Kubernetes, POSIX FUSE mount, S3 API, S3 Gateway, Hadoop, WebDAV, encryption, Erasure Coding.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x
- label the machine with its own label
- Mount Data Disk

## Install the app

```shell
sealos run docker.io/labring/seaweedfs:v3.67
```

Get app status

```shell
$ helm -n seaweedfs ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n seaweedfs uninstall seaweedfs
```

## Configuration

Refer to  `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/seaweedfs:v3.67 -e HELM_OPTS="--set filer.s3.enabled=true"
```
