# kargo

[Kargo](https://github.com/akuity/kargo)  is a next-generation continuous delivery and application lifecycle orchestration platform for Kubernetes.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x
- Cert-Manager
- Argo CD

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/kargo:v0.2.1
```

Get app status

```shell
$ helm -n kargo ls
```

## Access kargo

Default password is `admin`

```
https://<node-ip>:<node-port>
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n kargo uninstall kargo
```

## Configuration

Refer to kargo values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/kargo:v0.1.0 \
-e NAME=my-kargo -e NAMESPACE=my-kargo -e HELM_OPTS="--set api.adminAccount.password=admin \
--set api.adminAccount.tokenSigningKey=iwishtowashmyirishwristwatch \
--set api.service.type=NodePort"
