# Zabbix

[Helm chart](https://git.zabbix.com/projects/ZT/repos/kubernetes-helm/browse) to install components for the Kubernetes cluster monitoring.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos
- Helm

## Install the app

```shell
sealos run docker.io/labring/zabbix-agent:v7.0.0
```

Get app status

```shell
$ helm -n monitoring ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n monitoring uninstall zabbix-agent
```

## Configuration

Refer to  `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/zabbix-agent:v7.0.0 -e HELM_OPTS="--set key=value"
```
