## Overview

ingress-nginx is an Ingress controller for Kubernetes using [NGINX](https://www.nginx.org/) as a reverse proxy and load balancer.

The main expose type for ingress-nginx service:

- loadbalancer(default)
- nodeport
- hostnetwork

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos v4.x
- helm v3.x

## Get started

Install with sealos run

```shell
sealos run docker.io/labring/ingress-nginx:v1.8.1
```

Bare-metal considerations:  [metallb](https://metallb.universe.tf/) or other load-balancer implementation need installed to your bare metal Kubernetes clusters for LoadBalancer service type of ingress-nginx.

## Custome configuraton

Custome ingress-nginx helm values with --set.

```bash
sealos run docker.io/labring/ingress-nginx:v1.8.1 \
  -e HELM_OPTS="--set controller.hostNetwork=true --set controller.service.enabled=false"
```

## Expose with hostnetwork

1、Create a sealos config file, the content of the `data` section will merge into ingress-nginx helm values file.

```yaml
cat <<EOF>ingress-nginx-config.yaml
apiVersion: apps.sealos.io/v1beta1
kind: Config
metadata:
  name: ingress-nginx-config
spec:
  path: charts/ingress-nginx/values.yaml
  match: docker.io/labring/ingress-nginx:v1.8.1
  strategy: merge
  data: |
    controller:
      hostNetwork: true
      kind: DaemonSet
      service:
        type: ClusterIP
      nodeSelector:
        node: ingress-gateway
EOF
```

Notes: The value of the `path` field is bound to the installation command and is fixed. Do not modify it.

2、Label the nodes that you want to run the ingress-nginx controller

```
kubectl label nodes ubuntu node=ingress-gateway
```

3、Install ingress-nginx with custome config.

```shell
sealos run labring/ingress-nginx:v1.8.1 --config-file ingress-nginx-config.yaml
```

Check the operator pods status.

```shell
$ kubectl -n redis-operator get pods 
NAME                             READY   STATUS    RESTARTS      AGE
redis-operator-8fccdbc45-cbq2z   1/1     Running   0             4m15s
redis-operator-8fccdbc45-r8z4h   1/1     Running   1 (39m ago)   40m
```

All support values:

https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/values.yaml

## Expose with nodeport

1. Create a sealos config file, the content of the `data` section will merge into ingress-nginx helm values file.

```yaml
cat <<EOF>ingress-nginx-config.yaml
apiVersion: apps.sealos.io/v1beta1
kind: Config
metadata:
  name: ingress-nginx-config
spec:
  path: charts/ingress-nginx/values.yaml
  match: docker.io/labring/ingress-nginx:v1.8.1
  strategy: merge
  data: |
    controller:
      service:
        type: NodePort
EOF
```

Notes: The value of the `path` field is bound to the installation command and is fixed. Do not modify it.

2. Install ingress-nginx with custome config.

```shell
sealos run labring/ingress-nginx:v1.8.1 --config-file ingress-nginx-config.yaml
```
## Uninstall

```shell
sealos run docker.io/labring/ingress-nginx:v1.8.1 -e uninstall=true
```
