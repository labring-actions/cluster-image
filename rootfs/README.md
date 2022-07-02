# 安装方法
1. 下载并安装sealos, sealos是个golang的二进制工具，直接下载拷贝到bin目录即可
```
wget -c https://sealyun.oss-cn-beijing.aliyuncs.com/latest/sealos && \
chmod +x sealos && mv sealos /usr/bin
```
2. 服务中心下载离线[资源包](https://www.sealyun.com/goodsList)
3. 安装一个三master的kubernetes集群
```
sealos init --passwd '123456' \
	--master 192.168.0.2  --master 192.168.0.3  --master 192.168.0.4  \
	--node 192.168.0.5 \
	--pkg-url /root/kube1.22.0.tar.gz \
	--version v1.22.0
```
# 安装常见问题请见下面链接
https://github.com/fanux/sealos/issues

# 技术支持
请加入QQ群（98488045) 联系稳定负责人
