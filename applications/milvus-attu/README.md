# Milvus-attu

[Attu](https://github.com/zilliztech/attu) is an all-in-one milvus administration tool. With Attu, you can dramatically reduce the cost of managing milvus.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x
- milvus

## Install the app

This will install Milvus Standalone with helm:

```shell
$ sealos run docker.io/labring/milvus-attu:v2.3.6
```

Get app status

```shell
$ kubectl -n milvus get pods
```

## Access the app

Get attu service nodeport

```bash
$ kubectl -n milvus get svc
```

Access attu UI

```bash
http://<node-ip>:<node-port>
```

## Uninstalling the app

Uninstall with kubectl command

```shell
container_name=$(sealos ps -f ancestor=milvus-attu --notruncate --format "{{.ContainerName}}")
cd /var/lib/sealos/data/default/applications/${container_name}/workdir
kubectl -n milvus delete -f manifests/attu-k8s-deploy.yaml
```
