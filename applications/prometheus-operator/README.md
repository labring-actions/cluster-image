# prometheus-operator

[Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator) creates/configures/manages Prometheus clusters atop Kubernetes.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x

## Install the app

Only install prometheus-operator

```shell
sealos run docker.io/labring/prometheus-operator:v0.71.2
```

Get app status

```shell
$ kubectl -n default get pods
```

## Uninstalling the app

Uninstall with helm command

```shell
container_name=$(sealos ps -f ancestor=prometheus-operator --notruncate --format "{{.ContainerName}}")
cd /var/lib/sealos/data/default/applications/${container_name}/workdir
kubectl delete -f manifests/bundle.yaml
```
