## zadig

```shell
wget https://github.com/labring/sealos/releases/download/v4.3.0/sealos_4.3.0_linux_amd64.tar.gz
tar -zxvf sealos_4.3.0_linux_amd64.tar.gz sealos
chmod a+x sealos 
mv sealos /usr/bin/
```

```shell
sealos run --masters 172.31.64.100 --nodes 172.31.64.101,172.31.64.102,172.31.64.103 labring/kubernetes:v1.23.0 labring/helm:v3.12.0 labring/calico:v3.24.1 labring/coredns:v0.0.1 --passwd 'Fanux#123'
sealos run labring/openebs:v3.4.0
sealos run --env IP=172.31.64.100 labring/zadig:1.17.0
sealos run --env IP=172.31.64.100 --env HELM_OPTS="--set tags.minio=false" labring/zadig:1.17.0

```

