# milvus-operator

[milvus-operator](https://github.com/zilliztech/milvus-operator) , the kubernetes operator of Milvus.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x
- PV provisioner support in the underlying infrastructure

## Install the app

This will install Milvus Standalone with helm:

```shell
$ sealos run docker.io/labring/milvus-operator:v0.8.8
```

Get operator status

```shell
$ helm -n milvus-operator ls
```

Get app status

```bash
$ kubectl -n milvus get pods
```

## Uninstalling the app

Uninstall with helm command

```shell
kubectl -n milvus delete milvus my-release
helm -n milvus-operator uninstall milvus-operator
```

## Configuration

Get mount path which is `default-xxxxxx`.

```bash
container_name=$(sealos ps -f ancestor=istio-bookinfo --notruncate --format "{{.ContainerName}}")
cd /var/lib/sealos/data/default/applications/${container_name}/workdir
ls manifest
```

change to that path and apply sample yaml file

```bash
kubectl apply -f manifest/xxx.yaml
```
