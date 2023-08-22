# Argo-workflows

Workflow engine for Kubernetes.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- Helm 3.x.x

## Installing the app

```shell
$ sealos run docker.io/labring/argo-workflows:v3.4.10
```

Get pods status

```shell
$ kubectl -n argo-workflows get pods
NAME                                                  READY   STATUS    RESTARTS   AGE
argo-workflows-server-66948875c-7hlmb                 1/1     Running   0          18s
argo-workflows-workflow-controller-6f8bc6d85d-j8b89   1/1     Running   0          18s
```

Get service status

```shell
$ kubectl -n argo-workflows get svc
NAME                    TYPE       CLUSTER-IP   EXTERNAL-IP   PORT(S)          AGE
argo-workflows-server   NodePort   10.96.0.99   <none>        2746:32241/TCP   44m
```

## Access the app

```
https://192.168.1.10:32241
```

## Uninstalling the app

```shell
$ helm -n argo-workflows uninstall argo-workflows
```

## Configuration

Refer to  argo-workflows `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/argo-workflows:v3.4.10 \
-e NAME=myargo-workflows -e NAMESPACE=myargo-workflows -e HELM_OPTS="--set server.serviceType=NodePort"
```
