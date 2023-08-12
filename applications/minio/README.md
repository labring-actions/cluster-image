# Minio

MinIO is a High Performance Object Storage released under GNU Affero General Public License v3.0. It is API compatible with Amazon S3 cloud storage service. Use MinIO to build high performance infrastructure for machine learning, analytics and application data workloads.

## Install

```shell
sealos run docker.io/labring/minio:RELEASE.2023-07-07T07-13-57Z
```

custome values
```shell
sealos run docker.io/labring/minio:RELEASE.2023-07-07T07-13-57Z -e HELM_OPTS="--set service.type=NodePort --set consoleService.type=NodePort --set rootUser=admin --set rootPassword=minio123"
```

Get pods status

```shell
root@node1:~# kubectl -n minio get pods
NAME                    READY   STATUS    RESTARTS   AGE
minio-57d458499-slsvh   1/1     Running   0          25s
```

Get service status

```shell
root@node1:~# kubectl -n minio get svc
NAME            TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE
minio           NodePort   10.96.2.161   <none>        9000:32000/TCP   38s
minio-console   NodePort   10.96.0.148   <none>        9001:32001/TCP   38s
```

Get pvc status

```shell
root@node1:~# kubectl -n minio get pvc
NAME    STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS      AGE
minio   Bound    pvc-a0bfa03e-c2dd-49bc-9c16-065ef1d2013d   10Gi       RWO            piraeus-storage   68s
```

## Access minio console

Default username/password: `admin/minio123`，or get username/password from kubectl

```shell
kubectl -n minio get secret minio -ojsonpath='{.data.rootUser}' | base64 -d; echo
kubectl -n minio get secret minio -ojsonpath='{.data.rootPassword}' | base64 -d; echo
```

console UI

```shell
http://192.168.1.10:32001
```

## Uinstall

```shell
helm -n minio uninstall minio
```
