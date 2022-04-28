# cluster-image

升级shim脚本

```shell
systemctl stop image-cri-shim.service
wget https://gh.api.99988866.xyz/https://github.com//sealyun-market/image-cri-shim/releases/download/v0.0.8/image-cri-shim_0.0.8_linux_amd64.tar.gz
tar -zxvf image-cri-shim_0.0.8_linux_amd64.tar.gz
cp image-cri-shim /usr/bin/

cat > /etc/image-cri-shim.yaml << eof
shim: /var/run/image-cri-shim.sock
cri: /run/containerd/containerd.sock
address: http://sealos.hub:5000
force: true
debug: false
image: /var/lib/image-cri-shim
sync: 0
auth: admin:passw0rd
eof
systemctl restart image-cri-shim.service
```
