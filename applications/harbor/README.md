## Overview

This [Helm](https://github.com/kubernetes/helm) chart installs [Harbor](https://github.com/goharbor/harbor) in a Kubernetes cluster. 

## Install

1. Prerequisites:

- default storageclass is ready in your cluster.
- ingress-nginx is ready in your cluster, and expose with loadbalancer or hostnetwork.

2. Install harbor

```shell
$ sealos run docker.io/labring/harbor:v2.8.2
```

Custome config
```
$ sealos run docker.io/labring/harbor:v2.8.2 -e HELM_OPTS="--set harborAdminPassword=Harbor12345"
```

Get pods status

```
$ kubectl -n harbor get pods
```

Get ingress rule

```
$ kubectl -n harbor get ingress
```

Notes: harbor defalut expose type is ingress with ingress-nginx.

## Access harbor with UI

Access harbor in Brower， default username and password is `admin/Harbor12345`.

```shell
https://core.harbor.domain
```

## Access harbor with CLI

Get ca.crt and copy it to your docker client nodes.

```shell
kubectl -n harbor get secrets harbor-ingress -o jsonpath="{.data.ca\.crt}" | base64 -d >ca.crt
```

Create certs directory in containerd client node

```shell
mkdir -p /etc/containerd/certs.d/core.harbor.domain/
```

or docker
```
mkdir -p /etc/docker/certs.d/core.harbor.domain/
```

Copy ca.crt to the directory

```shell
scp ca.crt /etc/containerd/certs.d/core.harbor.domain/
```

Login harbor

```shell
docker login -u admin -p Harbor12345 https://core.harbor.domain
```

Push images

```shell
docker tag coredns/coredns:1.9.1 core.harbor.domain/library/coredns:1.9.1
docker push core.harbor.domain/library/coredns:1.9.1
```

## Uninstall

```shell
helm -n harbor uninstall harbor
```
