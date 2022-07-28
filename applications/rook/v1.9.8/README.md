### build

```
sealos build -f Dockerfile -t registry.cn-shenzhen.aliyuncs.com/cnmirror/rook:v1.9.8 .
```

images

```
wget https://raw.githubusercontent.com/rook/rook/v1.9.8/deploy/examples/images.txt
```

helm charts

```
helm repo add rook-release https://charts.rook.io/release
helm pull --version v1.9.8 --untar rook-release/rook-ceph rook-release/rook-ceph-cluster
```

## usage

this is for production config,you'll need three worker nodes with `8CPU/16G MEM` or more and each have one or more raw disk.

```
sealos run \
  --masters xxx \
  --nodes xxx,xxx,xxx -p 123456 \
  labring/kubernetes:v1.24.3 \
  labring/calico:v3.22.1 \
  labring/helm:v3.8.2 \
  registry.cn-shenzhen.aliyuncs.com/cnmirror/rook:v1.9.8
```

