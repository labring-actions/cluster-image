# koperator

Your window into the zookeeper-operator https://github.com/pravega/zookeeper-operator

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x

## Versions from helm
```
helm search repo --versions --regexp '\vpravega/zookeeper-operator\v'
NAME                      	CHART VERSION	APP VERSION	DESCRIPTION
pravega/zookeeper-operator	0.2.15       	0.2.15     	Zookeeper Operator Helm chart for Kubernetes
pravega/zookeeper-operator	0.2.14       	0.2.14     	Zookeeper Operator Helm chart for Kubernetes
pravega/zookeeper-operator	0.2.13       	0.2.13     	Zookeeper Operator Helm chart for Kubernetes
pravega/zookeeper-operator	0.2.12       	0.2.12     	Zookeeper Operator Helm chart for Kubernetes
pravega/zookeeper-operator	0.2.11       	0.2.11     	Zookeeper Operator Helm chart for Kubernetes
pravega/zookeeper-operator	0.2.10       	0.2.10     	Zookeeper Operator Helm chart for Kubernetes
pravega/zookeeper-operator	0.2.9        	0.2.9      	Zookeeper Operator Helm chart for Kubernetes
pravega/zookeeper-operator	0.2.8        	0.2.8      	Zookeeper Operator Helm chart for Kubernetes
```

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/zookeeper-operator:0.2.15
```

Get app status

```shell
$ helm -n zook-system ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n zook-system  uninstall zook
helm -n zook-system  uninstall zook-operator
```

## Configuration

Refer to zook-operator values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS= -e OPERATOR_HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/koperator:0.25.1
```
