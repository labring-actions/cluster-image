# grafana

The open-source platform for monitoring and observability.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- Helm 3.x.x

## Installing the app

```shell
$ sealos run docker.io/labring/grafana:v10.0.2
```

Get pods status

```shell
$ kubectl -n grafana get pods
NAME                       READY   STATUS    RESTARTS   AGE
grafana-6d6f6cf98f-qwrdh   1/1     Running   0          47s
```

Get service status

```shell
$ kubectl -n grafana get svc
NAME      TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
grafana   NodePort   10.96.3.182   <none>        80:30476/TCP   49s
```

## Access grafana

Get `admin` user secrets

```
kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

Access grafana

```
http://192.168.1.10:30476
```

## Uninstalling the app

```shell
helm -n grafana uninstall grafana
```

## Configuration

Refer to grafana `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `sealos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/grafana:v10.0.2 \
-e NAME=mygrafana -e NAMESPACE=mygrafana -e HELM_OPTS="--set service.type = NodePort
```

