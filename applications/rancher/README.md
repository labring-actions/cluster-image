## How to install

1、Install ingress controller

```shell
sealos run labring/ingress-nginx:4.1.0
```

2、Install cert-manager

```shell
sealos run labring/cert-manager:v1.8.0
```

3、Install rancher

```shell
sealos run labring/rancher:v2.6.9
```

## Access rancher UI

1、Change ingress-nginx to nodeport for access from out of the cluster

```shell
$ kubectl -n ingress-nginx edit svc ingress-nginx-controller
......
spec:
  type: NodePort
```

2、Config hosts resolve at local

```shell
node-ip  rancher.my.org 
```

access rancher dashboard

```shell
https://<node-ip>:30304
```

## Custome hostname or ingress controller

```shell
sealos run labring/rancher:v2.6.9 --env hostname=rancher.my.org --env ingressClassName=nginx
```

## Full size images

Notes: The above images are only minimal size. The full image is very large (30GB) , you can pull it from aliyun image registry. 

```shell
registry.cn-shenzhen.aliyuncs.com/labring/rancher:v2.6.9
```

You can check the full images list [here](https://github.com/rancher/rancher/releases/download/v2.6.9/rancher-images.txt). 
