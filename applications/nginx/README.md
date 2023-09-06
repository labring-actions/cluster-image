# Bitnami nginx

NGINX Open Source is a web server that can be also used as a reverse proxy, load balancer, and HTTP cache. Recommended for high-demanding sites due to its ability to provide faster content.

This app is packaged by [Bitnami nginx helm charts](https://github.com/bitnami/charts/tree/main/bitnami/nginx).

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/nginx:v1.23.4
```

Get app status

```shell
$ helm -n nginx ls
NAME                     READY   STATUS    RESTARTS   AGE
nginx-5469965c89-mhncn   1/1     Running   0          21s
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n nginx uninstall nginx
```

## Configuration

Refer to bitnami nginx [values.yaml](https://github.com/bitnami/charts/blob/main/bitnami/nginx/values.yaml) for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/nginx:v1.23.4 \
-e NAME=mynginx -e NAMESPACE=mynginx -e HELM_OPTS="--set service.type=LoadBalancer"
```

Alternatively, a YAML config file that specifies the values for the parameters can be provided while installing the app. For example,

1. Create a yaml config file `nginx-config.yaml`

```yaml
$ cat nginx-config.yaml
apiVersion: apps.sealos.io/v1beta1
kind: Config
metadata:
  name: nginx-config
spec:
  path: charts/nginx/values.yaml
  match: docker.io/labring/nginx:v1.23.4
  strategy: merge
  data: |
    service:
      type: LoadBalancer
```



Run with the yaml config file

```shell
$ sealos run docker.io/labring/nginx:v1.23.4 --config=nginx-config.yaml
```
