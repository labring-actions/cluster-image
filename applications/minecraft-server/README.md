# minecraft-server

[Minecraft](https://minecraft.net/en/) is a game about placing blocks and going on adventures.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos
- Helm
- PV provisioner support in the underlying infrastructure

## Install the app

```shell
sealos run docker.io/labring/minecraft-server:latest
```

Get app status

```shell
$ helm -n minecraft ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n minecraft uninstall minecraft
```

## Configuration

Refer to  `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/minecraft-server:latest -e HELM_OPTS=" \
--set minecraftServer.eula=true \
--set persistence.dataDir.enabled=true \
--set minecraftServer.serviceType=NodePort \
--set minecraftServer.onlineMode=false"
```
