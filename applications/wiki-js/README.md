## Wiki.js

(Wiki.js)[https://github.com/requarks/wiki] is a modern and powerful wiki app built on Node.js.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x
- PV provisioner support in the underlying infrastructure

## Install

```shell
sealos run docker.io/labring/wiki-js:v2.5.300 
```

## Uninstall

```shell
helm -n wiki-js uninstall wiki-js
```

## Configuration

Refer to wiki `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/wiki-js:v2.5.300 \
-e NAME=my-wiki-e NAMESPACE=my-wiki -e HELM_OPTS="--set service.type=NodePort"
```
