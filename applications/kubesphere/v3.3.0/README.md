## how to build

1、build command

```
 sealos build -f Dockerfile -t registry.cn-shenzhen.aliyuncs.com/cnmirror/kubesphere:v3.3.0 .
```

2、the `KubesphereImageList` comes from

```
wget https://github.com/kubesphere/ks-installer/releases/download/v3.3.0/images-list.txt -P images/shim/
cat images/shim/images-list.txt |grep -v "^#" > images/shim/KubesphereImageList
rm -rf images/shim/images-list.txt
```

3、the `kubesphere-installer.yaml`and `cluster-configuration.yaml` comes from

```
wget https://raw.githubusercontent.com/kubesphere/ks-installer/v3.3.0/deploy/kubesphere-installer.yaml -P manifests/
wget https://raw.githubusercontent.com/kubesphere/ks-installer/v3.3.0/deploy/cluster-configuration.yaml  -P manifests/
```

## how to use

prequires：openebs or other storage is needed by kubespere.

```
sealos run \
  --masters xxx --nodes xxx -p xxx \
  labring/kubernetes:v1.22.11 \
  labring/calico:v3.22.1 \
  labring/openebs:v1.9.0 \
  registry.cn-shenzhen.aliyuncs.com/cnmirror/kubesphere:v3.3.0
```



