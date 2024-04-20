# bitnami-thanos

[bitnami thanos](https://github.com/bitnami/charts/tree/main/bitnami/thanos) bootstraps a Thanos deployment on a Kubernetes cluster using the Helm package manager.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x
- PV provisioner support in the underlying infrastructure

## Install the app

```shell
sealos run docker.io/labring/bitnami-thanos:v0.33.0
```

Get app status

```shell
$ helm -n monitoring ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n monitoring uninstall thanos
```

## Configuration

Refer to bitnami-thanos `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```yaml
$ cat charts/thanos.values.yaml
existingObjstoreSecret: thanos-objstore
query:
  dnsDiscovery:
    sidecarsService: "prometheus-operated"
    sidecarsNamespace: "monitoring"
compactor:
  enabled: true
storegateway:
  enabled: true
metrics:
  enabled: true
  serviceMonitor:
    enabled: true
```

Install thanos

```shell
$ sealos run docker.io/labring/bitnami-thanos:v0.33.0 -e HELM_OPTS="-f charts/thanos.values.yaml"
```
