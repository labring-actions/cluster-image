# Bitnami nginx

NGINX Open Source is a web server that can be also used as a reverse proxy, load balancer, and HTTP cache. Recommended for high-demanding sites due to its ability to provide faster content.

This app is packaged by [Bitnami nginx helm charts](https://github.com/bitnami/charts/tree/main/bitnami/nginx).

## Install

```shell
sealos run docker.io/labring/nginx:v1.23.4
```

custome values
```shell
sealos run docker.io/labring/nginx:v1.23.4 -e NAME=mynginx -e NAMESPACE=mynginx -e HELM_OPTS="--set service.type=LoadBalancer"
```

Get pods status

```
root@ubuntu:~# kubectl -n nginx get pods 
NAME                     READY   STATUS    RESTARTS   AGE
nginx-5469965c89-mhncn   1/1     Running   0          21s
```

Get service status

```
root@ubuntu:~# kubectl -n nginx get svc
NAME    TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
nginx   NodePort   10.96.2.184   <none>        80:30208/TCP   23s
```

## Uinstall

```shell
sealos run docker.io/labring/nginx:v1.23.4 -e uninstall=true
```
