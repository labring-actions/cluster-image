# spinnaker-operator

The [Spinnaker Operator](https://blog.armory.io/spinnaker-operator/) is a Kubernetes operator to deploy and manage Spinnaker using familiar tools.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x
- Ingress-nginx
- minio

## Install the app

The ingress-nginx and minio should be installed first.

Prerequisites example

```bash
sealos run docker.io/labring/openebs:v3.9.0
sealos run docker.io/labring/minio:RELEASE.2023-10-07T15-07-38Z
sealos run docker.io/labring/metallb:v0.13.10 -e addresses="192.168.10.100-192.168.10.110"
sealos run docker.io/labring/ingress-nginx:v1.8.1
```

Install spinnaker

```shell
sealos run docker.io/labring/spinnaker-operator:v1.4.0
```

You can customize the following default configurations，refer to spinnaker-operator [options](https://github.com/armory/spinnaker-operator/blob/master/doc/options.md) for the full run-down on defaults.

```bash
$ sealos run docker.io/labring/spinnaker-operator:v1.4.0 \
-e domain="spinnaker.example.com" \
-e s3_endpoint="http://minio.minio:9000" \
-e s3_accessKeyId="admin" \
-e s3_secretAccessKey="minio123"
```

Get app status

```shell
$ kubectl -n spinnaker-operator get pods
$ kubectl -n spinnaker get pods
$ kubectl -n spinnaker get spinsvc
$ kubectl -n spinnaker get ingress
```

## Access Spinnaker UI

```bash
http://spinnaker.example.com
```

## Uninstalling the app

Uninstall with kubectl command

```shell
$ kubectl -n spinnaker delete spinsvc spinnaker
```
