### Build

Build command

```shell
sealos build -f Dockerfile -t registry.cn-qingdao.aliyuncs.com/labring/argocd:v2.4.8 .
```

helm charts

```shell
helm repo add argo https://argoproj.github.io/argo-helm
helm pull argo/argo-cd --version=4.10.5 --untar -d charts/
```

## Usage

1.Install argocd

```shell
sealos run registry.cn-qingdao.aliyuncs.com/labring/argocd:v2.4.8
```

2.Get service Nodeport

```shell
kubectl -n argocd get svc
```

3.Get  admin password

```shell
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

4.Access with browser
