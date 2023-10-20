# Argocd

Declarative Continuous Deployment for Kubernetes.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/argocd:v2.8.4
```

Get app status

```shell
$ helm -n argocd ls
```

## Access argocd

Default username and password `admin/admin1234`

```
https://<node-ip>:<node-port>
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n argocd uninstall argocd
```

## Configuration

Refer to argocd values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/argocd:v2.8.4 \
-e NAME=my-argocd -e NAMESPACE=my-argocd -e HELM_OPTS="--set server.service.type=NodePort \
--set configs.secret.argocdServerAdminPassword=xxx"
