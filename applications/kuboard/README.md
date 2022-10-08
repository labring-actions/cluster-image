
prequires：openebs or other storage is needed by kubegems.

```
sealos run \
  --masters xxx --nodes xxx -p xxx \
  labring/kubernetes:v1.23.10 \
  labring/helm:v3.8.2 \
  labring/calico:v3.22.1 \
  labring/coredns:v0.0.1 \
  labring/kuboard:v3
```


## how to use

Start kubegems with one click:
1. install sealos
```
wget https://github.com/labring/sealos/releases/download/v4.1.3/sealos_4.1.3_linux_amd64.tar.gz \
   && tar zxvf sealos_4.1.3_linux_amd64.tar.gz sealos && chmod +x sealos && mv sealos /usr/bin
```
2. install kuboard with k8s
```
sealos run \
  labring/kubernetes:v1.23.10 \
  labring/helm:v3.8.2 \
  labring/calico:v3.22.1 \
  labring/coredns:v0.0.1 \
  labring/kuboard:v3 --single
  
kubectl taint nodes --all node-role.kubernetes.io/master-
```
3. print success info
