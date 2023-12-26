# Bitnami wordpress

WordPress is one of the world’s most popular web publishing platforms for building blogs and websites. It can be customized via a wide selection of themes, extensions and plug-ins.

## Install

```shell
sealos run docker.io/labring/wordpress:v6.2.2
```

custome values
```shell
sealos run docker.io/labring/wordpress:v6.2.2 -e NAME=mywordpress -e NAMESPACE=mywordpress -e HELM_OPTS="--set service.type=LoadBalancer"
```

Get pods status

```shell
root@node1:~# kubectl -n wordpress get pods 
NAME                         READY   STATUS    RESTARTS   AGE
wordpress-56d49b4586-tt6t7   1/1     Running   0          98s
wordpress-mariadb-0          1/1     Running   0          97s
```

Get service status

```shell
root@node1:~# kubectl -n wordpress get svc
NAME                TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)                      AGE
wordpress           NodePort    10.96.2.45    <none>        80:32419/TCP,443:31400/TCP   76s
wordpress-mariadb   ClusterIP   10.96.1.211   <none>        3306/TCP                     76s
```

## Login wordpress

default username/password: `admin/wordpress`

Get admin password with kubectl
```shell
$ kubectl -n wordpress get secret wordpress -o jsonpath="{.data.wordpress-password}" | base64 --decode
```

```shell
https://192.168.1.10:31400
```
admin console
```
https://192.168.1.10:31400/admin
```

## Uninstall

```shell
helm -n wordpress uninstall wordpress
```
