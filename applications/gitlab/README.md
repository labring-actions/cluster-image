# GitLab

To install a cloud-native version of GitLab, use the GitLab Helm chart. This chart contains all the required components to get started and can scale to large deployments.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- metallb
- openebs

## Install

Prerequisites example

```shell
sealos run registry.cn-hongkong.aliyuncs.com/labring/openebs:v3.4.0
sealos run registry.cn-hongkong.aliyuncs.com/labring/metallb:v0.13.9 \
  -e addresses="192.168.72.200-192.168.72.210"
```

Run gitlab operator

```shell
sealos run docker.io/labring/gitlab:v16.2.2
```

Get pods status

```shell
$ kubectl -n gitlab get pods
NAME                                               READY   STATUS      RESTARTS      AGE
gitlab-certmanager-5ccbb85dd4-sltf5                1/1     Running     0             20h
gitlab-certmanager-cainjector-847fcfb65f-rdjmb     1/1     Running     0             20h
gitlab-certmanager-webhook-868446dc47-znvs7        1/1     Running     0             20h
gitlab-gitaly-0                                    1/1     Running     0             20h
gitlab-gitlab-exporter-687d89cc54-rhsxf            1/1     Running     0             20h
gitlab-gitlab-runner-75fdf76d6b-g69lf              1/1     Running     0             100m
gitlab-gitlab-shell-56fbf8cf5b-444gf               1/1     Running     0             20h
gitlab-gitlab-shell-56fbf8cf5b-n5chs               1/1     Running     0             20h
gitlab-issuer-2-btnrn                              0/1     Completed   0             100m
gitlab-kas-78f88d4bbd-2ntgp                        1/1     Running     3 (20h ago)   20h
gitlab-kas-78f88d4bbd-9pdxw                        1/1     Running     3 (20h ago)   20h
gitlab-migrations-2-sjrlk                          0/1     Completed   0             100m
gitlab-minio-bf6698696-2hfbt                       1/1     Running     0             20h
gitlab-minio-create-buckets-2-rktbx                0/1     Completed   0             100m
gitlab-nginx-ingress-controller-85f68bdcb8-66jft   1/1     Running     0             20h
gitlab-nginx-ingress-controller-85f68bdcb8-j7lwm   1/1     Running     0             20h
gitlab-postgresql-0                                2/2     Running     0             20h
gitlab-prometheus-server-6d8b995f5b-n98sb          2/2     Running     0             20h
gitlab-redis-master-0                              2/2     Running     0             20h
gitlab-registry-7c747bbb7f-d46cl                   1/1     Running     0             20h
gitlab-registry-7c747bbb7f-sxdr8                   1/1     Running     0             20h
gitlab-sidekiq-all-in-1-v2-777f78f4fb-6z6xz        1/1     Running     0             20h
gitlab-toolbox-58df596b7-pkd5j                     1/1     Running     0             20h
gitlab-webservice-default-867c4f9dc7-8bnkx         2/2     Running     0             20h
gitlab-webservice-default-867c4f9dc7-ckrp8         2/2     Running     0             20h
```

Get ingress service, makesure have `EXTERNAL-IP`

```shell
$ kubectl -n gitlab get svc gitlab-nginx-ingress-controller 
NAME                              TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)                                   AGE
gitlab-nginx-ingress-controller   LoadBalancer   10.96.0.222   192.168.72.100   80:32417/TCP,443:30282/TCP,22:31753/TCP   20h
```

Get ingress

```shell
$ kubectl -n gitlab get ingress
NAME                        CLASS          HOSTS                  ADDRESS          PORTS     AGE
gitlab-kas                  gitlab-nginx   kas.example.com        192.168.72.100   80, 443   20h
gitlab-minio                gitlab-nginx   minio.example.com      192.168.72.100   80, 443   20h
gitlab-registry             gitlab-nginx   registry.example.com   192.168.72.100   80, 443   20h
gitlab-webservice-default   gitlab-nginx   gitlab.example.com     192.168.72.100   80, 443   20h
```

## Access

Get `root` user password

```shell
kubectl -n gitlab get secret gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 -d; echo
```

Browser access to website

```shell
https://gitlab.example.com
```

## Git clone

**Use HTTPS **

```shell
kubectl -n gitlab get secrets gitlab-gitlab-tls -o jsonpath="{.data.tls\.crt}" | base64 -d >gitlab.example.com.crt
```

cp tls.crt to git client hosts

```shell
scp gitlab.example.com.crt ~/.ssl/gitlab.example.com.crt
mkdir ~/.ssl
git config --global http.sslCAInfo ~/.ssl/gitlab.example.com.crt
```

git clone example

```shell
git clone https://gitlab.example.com/root/demo.git
```

**Use SSH**

get git client hosts `id_rsa.pub`

```shell
cat /root/.ssh/id_rsa.pub  
```

upload to gitlab UI

```shell
Preferences-->SSH keys
```

git clone example

```shell
git clone git@gitlab.example.com:root/demo.git
```

## uninstall

```shell
helm -n gitlab uninstall gitlab
kubectl -n gitlab delete pvc --all
kubectl delete ns gitlab
```

