## 安装Sealos

```shell
wget https://github.com/labring/sealos/releases/download/v4.2.2/sealos_4.2.2_linux_amd64.tar.gz
tar -zxvf sealos_4.2.2_linux_amd64.tar.gz sealos
chmod a+x sealos 
mv sealos /usr/bin/
```

## 如何安装kb

```shell
sealos run --masters 172.31.64.100 --nodes 172.31.64.101,172.31.64.102,172.31.64.103 labring/kubernetes:v1.25.6 labring/helm:v3.11.3 labring/calico:v3.24.1 labring/coredns:v0.0.1 --passwd 'Fanux#123'
sealos run labring/openebs:v3.4.0
sealos run labring/cert-manager:v1.12.1
sealos run labring/kubeblocks:v0.6.0
```
