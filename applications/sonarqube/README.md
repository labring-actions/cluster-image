# sonarqube

SonarQube provides the capability to not only show health of an application but also to highlight issues newly introduced. With a Quality Gate in place, you can [Clean as You Code](https://www.sonarsource.com/blog/clean-as-you-code/) and therefore improve code quality systematically.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- Helm 3.x.x
- PV provisioner support in the underlying infrastructure

## Installing the app

```shell
$ sealos run docker.io/labring/sonarqube:v10.1.0
```

Get pods status

```shell
$ kubectl -n sonarqube get pods
NAME                     READY   STATUS    RESTARTS   AGE
sonarqube-postgresql-0   1/1     Running   0          4m26s
sonarqube-sonarqube-0    1/1     Running   0          4m26s
```

Get service status

```shell
$ kubectl -n sonarqube get svc
NAME                            TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE
sonarqube-postgresql            ClusterIP   10.96.3.4     <none>        5432/TCP         4m32s
sonarqube-postgresql-headless   ClusterIP   None          <none>        5432/TCP         4m32s
sonarqube-sonarqube             NodePort    10.96.1.147   <none>        9000:31123/TCP   4m32s
```

## Uninstalling the app

```shell
$ helm -n sonarqube uninstall sonarqube
```

## Access sonarqube

Default username passwrod: `admin/admin`
```
http://192.168.1.10:31123
```

## Configuration

Refer to sonarqube `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `sealos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/sonarqube:v10.1.0 \
-e NAME=mysonarqube-e NAMESPACE=mysonarqube -e HELM_OPTS="--set service.type=LoadBalancer"
```
