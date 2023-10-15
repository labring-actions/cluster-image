# Bitnami tomcat

Apache Tomcat is the most widely adopted application and web server in production today. Where WildFly is full JEE stack, Tomcat is a simpler servlet container and web server. Tomcat is lightweight and agile, simple to use and has a very large ecosystem of add-ons.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- Helm 3.x.x
- PV provisioner support in the underlying infrastructure

## Installing the app

```shell
$ sealos run docker.io/labring/tomcat:v10.1.11
```

Get pods status

```shell
$ kubectl -n tomcat get pods 
NAME                     READY   STATUS    RESTARTS   AGE
tomcat-99499955f-nqw62   1/1     Running   0          2m44s
```

Get service status

```shell
$ kubectl -n tomcat get svc
NAME     TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
tomcat   NodePort   10.96.3.202   <none>        80:30665/TCP   3m14s
```

## Uninstalling the app

```shell
$ helm -n tomcat uninstall tomcat
```

## Configuration

Refer to bitnami tomcat `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `sealos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/tomcat:v10.1.11 \
-e NAME=mytomcat-e NAMESPACE=mytomcat -e HELM_OPTS="--set service.type=LoadBalancer"
```

Alternatively, a YAML config file that specifies the values for the parameters can be provided while installing the app. For example,

1. Create a yaml config file `tomcat-config.yaml`

```yaml
$ cat tomcat-config.yaml
apiVersion: apps.sealos.io/v1beta1
kind: Config
metadata:
  name: tomcat-config
spec:
  path: charts/tomcat.values.yaml
  match: docker.io/labring/tomcat:v10.1.11
  strategy: override
  data: |
    service:
      type: LoadBalancer
```

Run with the yaml config file

```shell
$ sealos run docker.io/labring/tomcat:v10.1.11 \
--config=tomcat-config.yaml -e HELM_OPTS="-f charts/tomcat.values.yaml"
```
