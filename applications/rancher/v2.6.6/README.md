## how to build

1、build command

```
sealos build -f Dockerfile -t registry.cn-shenzhen.aliyuncs.com/cnmirror/rancher:v2.6.6
```

2、the `rancherImages` comes from

```
wget https://github.com/rancher/rancher/releases/download/v2.6.6/rancher-images.txt -P images/shim/
sort -u images/shim/rancher-images.txt -o images/shim/rancherImages
rm -rf images/shim/rancher-images.txt
```

3、the `rancher` directory comes from:

```
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm pull rancher-stable/rancher
tar -zxvf rancher-2.6.6.tgz 
rm -rf rancher-2.6.6.tgz 
```



## how to use

1、install ingress-nginx first, rancher need it

```

sealos run \
  --masters 192.168.72.50,192.168.72.51,192.168.72.52 \
  --nodes 192.168.72.53 -p 123456 \
  labring/kubernetes:v1.23.8 \
  labring/calico:v3.22.1 \
  labring/helm:v3.8.2 \
  labring/ingress-nginx:4.1.0 \
  labring/cert-manager:v1.8.0
```

2、wait above ready，then run rancher

```
sealos run registry.cn-shenzhen.aliyuncs.com/cnmirror/rancher:v2.6.6
```



## other config need

1、change ingress-nginx to nodeport for access from out of the cluster

```
# kubectl -n ingress-nginx edit svc ingress-nginx-controller
spec:
  type: NodePort
```



2、fix ingress-nginx ingress-class problems, add

```
root@node01:~# kubectl -n cattle-system edit ingress rancher
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    ......  
    kubernetes.io/ingress.class: "nginx" 
```



3、config dns resolve at local

```
node-ip  rancher.my.org 
```

access rancher dashboard

```
https://<node-ip>:30304/
```

