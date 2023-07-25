# GitLab Operator

The [GitLab operator](https://gitlab.com/gitlab-org/cloud-native/gitlab-operator) aims to manage the full lifecycle of GitLab instances in your Kubernetes.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- cert-manager
- metallb
- openebs

## Install

Prerequisites example

```shell
sealos run registry.cn-hongkong.aliyuncs.com/labring/openebs:v3.4.0
sealos run registry.cn-hongkong.aliyuncs.com/labring/cert-manager:v1.12.1
sealos run registry.cn-hongkong.aliyuncs.com/labring/metallb:v0.13.9 \
  -e addresses="192.168.72.200-192.168.72.210"
```

Run gitlab operator

```shell
sealos run docker.io/labring/gitlab-operator:v0.21.2 
```

Default domain is `example.com`, you can custome domain with
```
sealos run docker.io/labring/gitlab-operator:v0.21.2 -e DOMAIN=sealos.com
```

Get pods status

```shell
root@ubuntu:~# kubectl -n gitlab-system get pods
NAME                                              READY   STATUS      RESTARTS   AGE
gitlab-controller-manager-8f9956d6f-2p6r5         2/2     Running     0          8m18s
gitlab-gitaly-0                                   1/1     Running     0          5m47s
gitlab-gitlab-exporter-667f78f944-2jnrh           1/1     Running     0          4m45s
gitlab-gitlab-shell-694787c69-ctm8k               1/1     Running     0          4m45s
gitlab-kas-656b75b95-gtmrv                        1/1     Running     0          4m45s
gitlab-migrations-1-f1b-1-pwrhl                   0/1     Completed   0          4m45s
gitlab-minio-6d6b498dd7-4cp7s                     1/1     Running     0          5m47s
gitlab-minio-create-buckets-1-p2kqr               0/1     Completed   0          5m47s
gitlab-nginx-ingress-controller-cdb4f99d6-x5wm9   1/1     Running     0          6m7s
gitlab-nginx-ingress-controller-cdb4f99d6-xsbtt   1/1     Running     0          6m7s
gitlab-postgresql-0                               2/2     Running     0          5m47s
gitlab-redis-master-0                             2/2     Running     0          5m47s
gitlab-registry-d79f974c-jqsbz                    1/1     Running     0          4m45s
gitlab-shared-secrets-1-bqa-vphj2                 0/1     Completed   0          6m7s
gitlab-sidekiq-all-in-1-v2-f5f8f94bf-wmd9h        1/1     Running     0          2m
gitlab-toolbox-bf9568d78-4rzdr                    1/1     Running     0          4m45s
gitlab-webservice-default-f6c98d85d-lb8hw         2/2     Running     0          2m
```

Get ingress service, makesure have `EXTERNAL-IP`

```shell
root@ubuntu:~# kubectl -n gitlab-system get svc gitlab-nginx-ingress-controller
NAME                              TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)                                   AGE
gitlab-nginx-ingress-controller   LoadBalancer   10.96.3.193   192.168.72.200   80:32601/TCP,443:31750/TCP,22:31496/TCP   10m
```

Get ingress

```shell
root@ubuntu:~# kubectl -n gitlab-system get ingress
NAME                        CLASS          HOSTS                  ADDRESS   PORTS     AGE
gitlab-kas                  gitlab-nginx   kas.example.com                  80, 443   5m11s
gitlab-minio                gitlab-nginx   minio.example.com                80, 443   6m13s
gitlab-registry             gitlab-nginx   registry.example.com             80, 443   5m11s
gitlab-webservice-default   gitlab-nginx   gitlab.example.com               80, 443   5m11s
```

## Access

Get `root` user password

```shell
kubectl -n gitlab-system get secret gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 -d; echo
```

Browser access to website, Add DNS resolution to external ip: gitlab.example.com --> 192.168.72.200

```shell
https://gitlab.example.com
```

## Git clone

**Use HTTPS**

```shell
kubectl -n gitlab-system get secrets gitlab-gitlab-tls -o jsonpath="{.data.tls\.crt}" | base64 -d >gitlab.example.com.crt
```

cp tls.crt to git client hosts

```shell
mkdir ~/.ssl
scp gitlab.example.com.crt ~/.ssl/gitlab.example.com.crt
git config --global http.sslCAInfo ~/.ssl/gitlab.example.com.crt
```
or you can skip ssl verify
```
git config --global http.sslVerify false
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
