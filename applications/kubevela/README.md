# Kubevela

[KubeVela](https://github.com/kubevela/kubevela) is a modern application delivery platform that makes deploying and operating applications across today's hybrid, multi-cloud environments easier, faster and more reliable.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/kubevela:v1.9.6
```

Get app status

```shell
$ helm -n vela-system ls
```

## Access velaux

```
kubectl -n vela-system get svc
``

Default username and password: `admin/VelaUX12345`


## Uninstalling the app

Uninstall with helm command

```shell
helm -n vela-system uninstall kubevela
```

## Configuration

Refer to kubevela values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/kubevela:v1.9.6 \
-e NAME=my-kubevela -e NAMESPACE=my-kubevela -e HELM_OPTS="--set webhookService.type=NodePort"
```
