## Jenkins

In a nutshell, Jenkins is the leading open-source automation server. Built with Java, it provides over 1,800 [plugins](https://plugins.jenkins.io/) to support automating virtually anything, so that humans can spend their time doing things machines cannot.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- default storageclass

## Install

```shell
sealos run docker.io/labring/jenkins:v2.401.3
```

Custome values
```shell
sealos run docker.io/labring/jenkins:v2.401.3 -e HELM_OPTS="--set controller.serviceType=NodePort"
```

Get pods status

```shell
root@ubuntu:~# kubectl -n jenkins get pods
NAME        READY   STATUS    RESTARTS   AGE
jenkins-0   2/2     Running   0          6m38s
```

Get service status

```shell
root@ubuntu:~# kubectl -n jenkins get svc
NAME            TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE
jenkins         NodePort    10.96.1.140   <none>        8080:31370/TCP   6m58s
jenkins-agent   ClusterIP   10.96.0.73    <none>        50000/TCP        6m58s
```

## Uinstall

```shell
$ helm -n jenkins uninstall jenkins
```
