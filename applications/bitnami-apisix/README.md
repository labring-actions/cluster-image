# Bitnami-apisix

Apache APISIX is high-performance, real-time API Gateway. Features load balancing, dynamic upstream, canary release, circuit breaking, authentication, observability, amongst others.

helm repo：https://github.com/bitnami/charts/tree/main/bitnami/apisix

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x
- PV provisioner support in the underlying infrastructure

## Install the app

```shell
sealos run docker.io/labring/bitnami-apisix:v3.6.0
```

Get app status

```shell
$ helm -n apisix ls
```

## Access apisix dashboard

Default username/password is `admin/admin`

`````
http://<loadbalancer-ip>
`````


## Uninstalling the app

Uninstall with helm command

```shell
helm -n apisix uninstall apisix
```

## Configuration

Refer to apisix  `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/bitnami-apisix:v3.6.0 -e HELM_OPTS="--set dashboard.username=admin \
--set dashboard.password=admin"
```
