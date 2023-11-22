# Spinnaker

[Spinnaker](https://github.com/spinnaker/spinnaker) is an open source, multi-cloud continuous delivery platform for releasing software changes with high velocity and confidence.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x
- Minio
- Ingress-nginx
- PV provisioner support in the underlying infrastructure

## Install the app

Prerequisites example

```bash
sealos run docker.io/labring/metallb:v0.13.10 -e addresses="192.168.10.100-192.168.10.110"
sealos run docker.io/labring/ingress-nginx:v1.8.1
sealos run docker.io/labring/minio:RELEASE.2023-10-07T15-07-38Z
```

Install spinnaker

```shell
sealos run docker.io/labring/spinnaker:v1.32.2
```

Get app status

```shell
$ kubectl -n spinnaker get pods
```

Custome config

```bash
$ sealos run docker.io/labring/spinnaker:v1.32.2 \
-e domain="spinnaker.example.com" \
-e s3_endpoint="http://minio.minio:9000" \
-e s3_accessKeyId="admin" \
-e s3_secretAccessKey="minio123"
```

## Uninstalling the app

```bash
$ kubectl exec -it -c halyard deploy/halyard -- bash
bash-5.0$ hal deploy clean -q
```
