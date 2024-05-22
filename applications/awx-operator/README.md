# awx-operator

[Ansible AWX operator](https://github.com/ansible/awx-operator) for Kubernetes built with Operator SDK and Ansible.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x
- PV provisioner support in the underlying infrastructure

## Install the app

```shell
sealos run docker.io/labring/awx-operator:v2.16.1
```

Get app status

```shell
$ helm -n awx ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n awx uninstall awx
```

## Configuration

Refer to  `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/awx-operator:v2.16.1 -e HELM_OPTS=" \
--set AWX.enabled=true \
--set AWX.spec.service_type=NodePort \
--set AWX.spec.projects_persistence=true \
--set AWX.spec.projects_storage_access_mode=ReadWriteOnce"
```
