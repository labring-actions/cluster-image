# Bitnami tomcat

Apache Tomcat is the most widely adopted application and web server in production today. Where WildFly is full JEE stack, Tomcat is a simpler servlet container and web server. Tomcat is lightweight and agile, simple to use and has a very large ecosystem of add-ons

## Install

```shell
sealos run docker.io/labring/tomcat:v10.1.11
```

custome values
```shell
sealos run docker.io/labring/tomcat:v10.1.11 -e NAME=mytomcat-e NAMESPACE=mytomcat -e HELM_OPTS="--set service.type=LoadBalancer"
```

Get pods status

```shell
root@ubuntu:~# kubectl -n tomcat get pods 
NAME                     READY   STATUS    RESTARTS   AGE
tomcat-99499955f-nqw62   1/1     Running   0          2m44s
```

Get service status

```shell
root@ubuntu:~# kubectl -n tomcat get svc
NAME     TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
tomcat   NodePort   10.96.3.202   <none>        80:30665/TCP   3m14s
```

## Uinstall

```shell
$ helm -n tomcat uninstall tomcat
```
