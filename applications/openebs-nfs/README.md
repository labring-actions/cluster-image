# Openebs-nfs

Operator for dynamically provisioning an NFS server on any Kubernetes Persistent Volume. Also creates an NFS volume on the dynamically provisioned server for enabling Kubernetes RWX volumes.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- Helm 3.x.x
- PV provisioner support in the underlying infrastructure(default storageclass)

## Installing the app

```shell
$ sealos run docker.io/labring/openebs-nfs:v0.10.0
```

Get pods status

```shell
$ kubectl -n nginx get pods 
NAME                     READY   STATUS    RESTARTS   AGE
nginx-5469965c89-mhncn   1/1     Running   0          21s
```

Get StorageClass status

```shell
root@ubuntu:~# kubectl get sc
NAME                         PROVISIONER         RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
openebs-hostpath (default)   openebs.io/local    Delete          WaitForFirstConsumer   false                  27d
openebs-kernel-nfs           openebs.io/nfsrwx   Delete          Immediate              false                  5m27s
```

## Uninstalling the app

```shell
helm -n openebs uninstall openebs-nfs
```

## Configuration

Refer to openebs-nfs values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/openebs-nfs:v0.10.0 \
-e NAME=myopenebs-nfs -e NAMESPACE=myopenebs-nfs -e HELM_OPTS="--set-string nfsStorageClass.backendStorageClass=openebs-hostpath
```
