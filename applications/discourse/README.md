# discourse

A platform for community discussion. Free, open, simple.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- Helm 3.x.x
- PV provisioner support in the underlying infrastructure

## Installing the app

Expose with nodeport

```shell
$ sealos run docker.io/labring/discourse:v3.0.6 -e HELM_OPTS="--set service.type=NodePort \
--set service.nodePorts.http=31234 \
--set host='192.168.1.10:31234'"
```

Get pods status

```shell
$ kubectl -n discourse get pods
NAME                         READY   STATUS    RESTARTS   AGE
discourse-794db65674-wx5jc   2/2     Running   0          94s
discourse-postgresql-0       1/1     Running   0          94s
discourse-redis-master-0     1/1     Running   0          94s
```

Get service status

```shell
$ kubectl -n discourse get svc
NAME                       TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
discourse                  NodePort    10.96.1.209   <none>        80:31234/TCP   97s
discourse-postgresql       ClusterIP   10.96.2.218   <none>        5432/TCP       97s
discourse-postgresql-hl    ClusterIP   None          <none>        5432/TCP       97s
discourse-redis-headless   ClusterIP   None          <none>        6379/TCP       97s
discourse-redis-master     ClusterIP   10.96.1.136   <none>        6379/TCP       97s
```

## Access discourse

Get default admin user `user` login password:
```
kubectl get secret --namespace "discourse" discourse-discourse \
-o jsonpath="{.data.discourse-password}" | base64 -d
```

Browser access the following link
```
http://192.168.1.10:31234
```

## Uninstalling the app

```shell
$ helm -n discourse uninstall discourse
```

## Configuration

Refer to discourse `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `sealos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/discourse:v3.0.6 \
-e NAME=mydiscourse -e NAMESPACE=mydiscourse -e HELM_OPTS="--set service.type=LoadBalancer"
```
