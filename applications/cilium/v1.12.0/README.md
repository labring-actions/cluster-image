### Build

build command

```
sealos build -f Dockerfile -t registry.cn-shenzhen.aliyuncs.com/cnmirror/cilium:v1.12.0 .
```

helm charts

```
helm repo add cilium https://helm.cilium.io/
cd charts
helm pull cilium/cilium --version=1.12.0 --untar
```

## Usage

Before install this cilium application，you have to meet some pre requirements，The most basic requirement is `Linux kernel>= 4.9.17`,suggest use ubuntu 22.04 LTS server which have a default kernel version of `5.15.0`.

1.Generate your own Clusterfile

```shell
sealos gen  \
  --masters 192.168.72.50 \
  --nodes 192.168.72.51,192.168.72.52 -p 123456 \
  labring/kubernetes:v1.24.3 \
  labring/helm:v3.8.2 \
  registry.cn-shenzhen.aliyuncs.com/cnmirror/cilium:v1.12.0 > Clusterfile
```

2.Add the follow kubeadm InitConfiguration to Clusterfile, cilium can replace kube-proxy,so we can skip install it for  kubernetes.

```yaml
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
skipPhases:
- addon/kube-proxy
```

and the Cluster file like this

```yaml
apiVersion: apps.sealos.io/v1beta1
kind: Cluster
metadata:
  creationTimestamp: null
  name: default
spec:
  hosts:
  - ips:
    - 192.168.72.50:22
    roles:
    - master
    - amd64
  - ips:
    - 192.168.72.51:22
    - 192.168.72.52:22
    roles:
    - node
    - amd64
  image:
  - labring/kubernetes:v1.24.3
  - labring/helm:v3.8.2
  - registry.cn-shenzhen.aliyuncs.com/cnmirror/cilium:v1.12.0
  ssh:
    passwd: "123456"
    pk: /root/.ssh/id_rsa
    port: 22
    user: root
status: {}
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
skipPhases:
- addon/kube-proxy
```

3.Install kubernetes and cilium

```
sealos apply -f Clusterfile
```