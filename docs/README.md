####

#### 编译集群镜像

所有的镜像都基于runtime目录中几个目录制作的

##### k8s镜像

1. runtime/containerd containerd相关的配置以及脚本
2. runtime/rootfs 公共的rootfs相关的配置以及脚本
3. hack/containerd.sh 下载二进制以及其他的配置修改的脚本、
4. hack/build.sh 编译k8s的集群镜像同时build  x86和arm64架构的镜像

##### APP 镜像

所有的镜像都是在 runtime/applications/$NAME/$VERSION 目录存放相关的配置

- NAME 是镜像名称
- VERSION 是镜像版本

最终会以 docker.io/labring/$NAME:$VERSION 以最终的镜像名称。

- docker.io/labring/$NAME:$VERSION-amd64 是AMD64架构
- docker.io/labring/$NAME:$VERSION-arm64 是ARM64架构

runtime/applications/$NAME/$VERSION 下存放 init.sh 主要是有一些二进制需要分开存放.
init.sh下载一些二进制使用，示例代码可以看helm和minio-operator的脚

##### 配置镜像

所有的镜像都是在 runtime/config/$NAME/$VERSION 目录存放相关的配置

- NAME 是镜像名称
- VERSION 是镜像版本

最终会以 docker.io/labring/$NAME:$VERSION 以最终的镜像名称。


##### 如何构建镜像

1. 在构建目录新建 manifests 并把对应的yaml放入，sealos build会自动解析其中的镜像版本
2. 在构建目录新建 charts 并把对应的chart放入，sealos build 会自动解析其中的镜像版本
3. 如果需要手动写镜像，在构建目录新建目录 images/shim 并写入imageList文件（文件名不限定）
4. 编写Dockerfile 
    ```dockerfile
    FROM scratch 
    COPY manifests ./app/manifests
    COPY charts ./app/charts
    COPY registry ./registry
    CMD ["kubectl apply -f app/manifests/"]
    ```
   主要是为了区分一下APP
