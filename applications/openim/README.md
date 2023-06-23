## 安装Sealos

```shell
wget https://github.com/labring/sealos/releases/download/v4.2.2/sealos_4.2.2_linux_amd64.tar.gz
tar -zxvf sealos_4.2.2_linux_amd64.tar.gz sealos
chmod a+x sealos 
mv sealos /usr/bin/
```

## 如何安装OpenIM

```shell
publicIP=8.217.112.83
sealos run --masters 172.31.64.100 --nodes 172.31.64.101,172.31.64.102,172.31.64.103 labring/kubernetes:v1.25.6 labring/helm:v3.11.3 labring/calico:v3.24.1 labring/coredns:v0.0.1 --passwd 'Fanux#123'
sealos run labring/openebs:v3.4.0
sealos run labring/cert-manager:v1.12.1
sealos run labring/bitnami-kafka:v22.1.5
sealos run labring/bitnami-mysql:v9.10.4
sealos run labring/bitnami-mongodb-sharded:6.0.2
sealos run labring/bitnami-zookeeper:v11.4.2
sealos run labring/bitnami-redis-cluster:v8.4.4
sealos run labring/bitnami-minio:v12.6.4
sealos run labring/istio:1.16.2-min
sealos run --env publicIP=8.217.106.70 labring/openim:errcode
```

