# Apache Pulsar

Apache Pulsar - distributed pub-sub messaging system.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x
- PV provisioner support in the underlying infrastructure

## Install the app

```shell
sealos run docker.io/labring/pulsar:v2.10.2
```

Get app status

```shell
$ helm -n pulsar ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n pulsar uninstall pulsar
kubectl -n pulsar delete pvc --all
```

## Configuration

Refer to pulsar `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/pulsar:v2.10.2  -e HELM_OPTS=" \
-f ./manifest/examples/values-one-node.yaml \
--set components.pulsar_manager=true \
--set kube-prometheus-stack.grafana.service.type=NodePort \
--set proxy.service.type=NodePort \
--set kube-prometheus-stack.grafana.service.type=NodePort"
```
