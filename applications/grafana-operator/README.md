# grafana-operator

[grafana-operator](https://github.com/grafana-operator/grafana-operator) for Kubernetes to manage Grafana instances and grafana resources.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- Helm 3.x.x

## Installing the app

```shell
$ sealos run docker.io/labring/grafana-operator:v5.3.0
```

Get pods status

```shell
$ kubectl -n grafana-operator get pods
NAME                                  READY   STATUS    RESTARTS   AGE
grafana-deployment-67bb956494-7m95x   1/1     Running   0          12m
grafana-operator-7d9b778698-gvtlj     1/1     Running   0          12m
```

Get service status

```shell
$ kubectl -n grafana-operator get svc
NAME                               TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE
grafana-operator-metrics-service   ClusterIP   10.96.0.245   <none>        9090/TCP         12m
grafana-service                    NodePort    10.96.2.126   <none>        3000:30827/TCP   12m
```

## Access grafana

Get user secrets

```shell
$ kubectl -n grafana-operator get secrets grafana-admin-credentials \
-o jsonpath="{.data.GF_SECURITY_ADMIN_USER}" | base64 --decode ; echo

$ kubectl -n grafana-operator get secrets grafana-admin-credentials \
-o jsonpath="{.data.GF_SECURITY_ADMIN_PASSWORD}" | base64 --decode ; echo
```

Access grafana

```
http://192.168.1.10:30827
```

## Uninstalling the app

```shell
helm -n grafana--operator uninstall grafana-operator
```

