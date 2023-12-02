# Argo-workflows

Workflow engine for Kubernetes.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- Helm 3.x.x
- argo-workflow

## Installing the app

```shell
$ sealos run docker.io/labring/argo-events:v1.8.1
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

## Uninstalling the app

```shell
$ helm -n argo-events uninstall argo-events
```
