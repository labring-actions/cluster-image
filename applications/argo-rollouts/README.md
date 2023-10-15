# Argo-rollouts

Progressive Delivery for Kubernetes.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- Helm 3.x.x

## Installing the app

```shell
$ sealos run docker.io/labring/argo-rollouts:v1.5.1
```

Get pods status

```shell
$ kubectl -n argo-rollouts get pods
NAME                                       READY   STATUS    RESTARTS   AGE
argo-rollouts-dashboard-798c66cc8c-wktqc   1/1     Running   0          2m48s
argo-rollouts-db69b7d76-qh2cv              1/1     Running   0          2m48s
argo-rollouts-db69b7d76-x2ftn              1/1     Running   0          2m48s
```

Get service status

```shell
$ kubectl -n argo-rollouts get svc
NAME                      TYPE       CLUSTER-IP   EXTERNAL-IP   PORT(S)          AGE
argo-rollouts-dashboard   NodePort   10.96.1.97   <none>        3100:31584/TCP   2m50s
```

## Access the app

```
https://192.168.1.10:31584
```

## Uninstalling the app

```shell
$ helm -n argo-rollouts uninstall argo-rollouts
```

## Configuration

Refer to  argo-rollouts `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `sealos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/argo-rollouts:v1.5.1 \
-e NAME=myargo-rollouts -e NAMESPACE=myargo-rollouts -e HELM_OPTS="--set dashboard.enabled=true"
```
