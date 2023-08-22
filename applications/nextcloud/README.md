# Nextcloud

Nextcloud server, a safe home for all your data.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- Helm 3.x.x
- PV provisioner support in the underlying infrastructure

## Installing the app

```shell
$ sealos run docker.io/labring/nextcloud:v27.0.2 -e HELM_OPTS=" \
--set persistence.enabled=true \
--set service.type=NodePort \
--set service.nodePort=30808 \
--set nextcloud.host=192.168.1.10.nip.io \
"
```

Get pods status

```shell
$ kubectl -n nextcloud get pods
NAME                        READY   STATUS    RESTARTS   AGE
nextcloud-7d65c8b9d-llwtj   1/1     Running   0          5m58s
```

Get service status

```shell
$ kubectl -n nextcloud get svc
NAME        TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE
nextcloud   NodePort   10.96.0.126   <none>        8080:30808/TCP   6m1s
```

## Access the app

Default username and password: `admin/changeme`

```
http://192.168.1.10.nip.io:30808
```

## Uninstalling the app

```shell
$ helm -n nextcloud uninstall nextcloud
```

## Configuration

Refer to  nextcloud  `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/nextcloud:v27.0.2 \
-e NAME=mynextcloud -e NAMESPACE=mynextcloud -e HELM_OPTS="--set service.type=NodePort"
```
