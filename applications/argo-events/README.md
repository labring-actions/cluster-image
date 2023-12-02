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
$ kubectl get pods -n argo-events
NAME                                              READY   STATUS    RESTARTS   AGE
argo-events-controller-manager-6f8fcdc964-vnwzb   1/1     Running   0          8m46s
events-webhook-54fc554c76-4nl7m                   1/1     Running   0          8m46s
```

Get service status

```shell
$ kubectl -n argo-events get svc
NAME             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
events-webhook   ClusterIP   10.96.194.202   <none>        443/TCP   9m3s
```

## Uninstalling the app

```shell
$ helm -n argo-events uninstall argo-events
```
