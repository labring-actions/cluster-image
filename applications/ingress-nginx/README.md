## Overview

ingress-nginx is an Ingress controller for Kubernetes using [NGINX](https://www.nginx.org/) as a reverse proxy and load balancer.

The main expose type for ingress-nginx service:

- loadbalancer(default)
- nodeport
- hostnetwork

## Get started

Install with sealos run

```shell
sealos run labring/ingress-nginx:v1.5.1
```

Get pods status

```shell
$ kubectl -n ingress-nginx get pods 
NAME                                        READY   STATUS    RESTARTS   AGE
ingress-nginx-controller-8574b6d7c9-h5c25   1/1     Running   0          11m
```

Get service status

```shell
$ kubectl -n ingress-nginx get svc
NAME                                 TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   10.96.2.159   192.168.72.200   80:31503/TCP,443:32503/TCP   11m
ingress-nginx-controller-admission   ClusterIP      10.96.2.141   <none>           443/TCP                      11m
```

Bare-metal considerations:  [metallb](https://metallb.universe.tf/) or other load-balancer implementation need installed to your bare metal Kubernetes clusters for LoadBalancer service type of ingress-nginx.

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
  match: labring/ingress-nginx:v1.5.1
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
sealos run labring/ingress-nginx:v1.5.1 --config-file ingress-nginx-config.yaml
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
  match: labring/ingress-nginx:v1.5.1
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
sealos run labring/ingress-nginx:v1.5.1 --config-file ingress-nginx-config.yaml
```
## Uninstall

Uninstall with helm comand.

```shell
helm -n ingress-nginx uninstall ingress-nginx
```
