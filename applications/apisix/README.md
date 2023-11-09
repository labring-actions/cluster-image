# Apisix

Apache APISIX is a dynamic, real-time, high-performance API Gateway.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x
-  PV provisioner support in the underlying infrastructure

## Install the app

```shell
sealos run docker.io/labring/apisix:v3.6.0
```

Get app status

```shell
$ helm -n ingress-apisix ls
```

## Access apisix dashboard

Default username/password is `admin/admin`

`````
http://<node-ip>:<node-port>
`````

## Uninstalling the app

Uninstall with helm command

```shell
helm -n ingress-apisix uninstall apisix
```

## Configuration

Refer to apisix`values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/apisix:v3.6.0  \
-e HELM_OPTS="--set gateway.type=NodePort  \
--set ingress-controller.enabled=true \
--set ingress-controller.config.apisix.serviceNamespace=ingress-apisix \
--set ingress-controller.config.apisix.adminAPIVersion=v3 \
--set dashboard.enabled=true \
--set dashboard.service.type=NodePort \
"
```
