# Jenkins Operator

Kubernetes native Jenkins Operator.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- Helm 3.x.x
- PV provisioner support in the underlying infrastructure

## Installing the app

```shell
$ sealos run docker.io/labring/jenkins-operator:v0.8.0-beta2
```

Get pods status

```shell
$ kubectl -n jenkins-operator get pods
NAME                                READY   STATUS    RESTARTS   AGE
jenkins-jenkins                     2/2     Running   0          21s
jenkins-operator-5fb4b47c84-nnwlw   1/1     Running   0          5m54s
```

Get service status

```shell
$ kubectl -n jenkins-operator get svc
NAME                             TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE
jenkins-operator-http-jenkins    NodePort    10.96.0.241   <none>        8080:31126/TCP   3m56s
jenkins-operator-slave-jenkins   ClusterIP   10.96.3.37    <none>        50000/TCP        3m56s
```

## Access the app
Get default username and password
```
kubectl --namespace jenkins-operator get secret jenkins-operator-credentials-jenkins \
-o 'jsonpath={.data.user}' | base64 -d

kubectl --namespace jenkins-operator get secret jenkins-operator-credentials-jenkins \
-o 'jsonpath={.data.password}' | base64 -d
```
Brower access the follow url
```
http://192.168.1.10:31126
```

## Uninstalling the app

```shell
$ helm -n jenkins-operator uninstall  jenkins-operator 
```

## Configuration

Refer to  jenkins-operator `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/jenkins-operator:v0.8.0-beta2 \
-e NAME=myjenkins-operator -e NAMESPACE=myjenkins-operator -e HELM_OPTS="--set jenkins.service.type=LoadBalancer"
```
