# Gitea

Gitea provides a Helm Chart to allow for installation on kubernetes.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- Helm 3.x.x
- PV provisioner support in the underlying infrastructure

## Installing the app

```shell
$ sealos run docker.io/labring/gitea:v1.20.3
```

## Uninstalling the app

```shell
$ helm -n gitea uninstall gitea
```

## Access the app

Makeysure ingress loadbalancer ip have dns relosve

```shell
ingress service with <loadbalancer ip> --> git.example.com
```

Access gitea，the default username/password is `gitea_admin/gitea_admin`

```shell
http://git.example.com/
```

## Configuration

Refer to gitea `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `sealos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/gitea:v1.20.3 \
-e NAME=mygitea -e NAMESPACE=mygitea -e HELM_OPTS="--set gitea.admin.password=gitea_admin --set ingress.enabled=true"
```

## ssh clone support

Config ingress nginx support forword TCP SSH 22 port.

1、create and apply configmap


```yaml
cat <<EOF>gitea-ingress-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: gitea-ssh-tcp-services
  namespace: ingress-nginx
data:
  22: "gitea/gitea-ssh:22"
EOF
```

2、change ingress-nginx args


```yaml
$ kubectl -n ingress-nginx edit deployment ingress-nginx-controller
    spec:
      containers:
      - args:
        - /nginx-ingress-controller
        - --tcp-services-configmap=$(POD_NAMESPACE)/gitea-ssh-tcp-services
```

3、change ingress-nginx service, add port 22 


```yaml
$ kubectl -n ingress-nginx edit svc ingress-nginx-controller
  ports:
  - name: 22-tcp
    nodePort: 30957
    port: 22
    protocol: TCP
    targetPort: 22
```

config gitea to import local host ssh public key

```
$ cat /root/.ssh/id_rsa.pub 
```

login gitea ui，add content to

```
repository-->settings-->deploy keys --> add deploy keys
```


clone example


```shell
$ git clone git@git.example.com:gitea_admin/test.git
Cloning into 'test'...
remote: Enumerating objects: 6, done.
remote: Counting objects: 100% (6/6), done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 6 (delta 0), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (6/6), done.
```
