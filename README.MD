# cluster-image

### 直接创建ISSUE 支持的镜像

- [APP集群镜像](https://github.com/labring/cluster-image/issues/new?assignees=&labels=&template=autobuild-apps.md&title=【Auto-build】helm)
- [配置集群镜像](https://github.com/labring/cluster-image/issues/new?assignees=&labels=&template=autobuild-configs.md&title=【Auto-build】coredns)
- [Docker镜像](https://github.com/labring/cluster-image/issues/new?assignees=&labels=&template=autobuild-docker-apps.md&title=【Auto-build】cri) (暂不支持Run)
- [大APP集群镜像](https://github.com/labring/cluster-image/issues/new?assignees=&labels=&template=autobuild-hosted.md&title=【Auto-build】athenaserving)

#### 说明

镜像配置存放位置

```
- applications 
  - argocd 应用名称
    - v2.4.8 版本
      - Dockerfile/Kubefile
      - init.sh
      
```

如何构建?

1. 目录下的init.sh 根据实际需求，一般是需要下载一些分架构的二进制使用，比如helm、kubectl-minio相关
2. Docker/Kubefile 都支持
3. 构建规则
   1. charts目录 放一些集群镜像需要的chart,k8s根据扫描的chart获取镜像build出registry目录放到与Kubefile同级的目录
   2. manifests目录直接放一些yaml配置，k8s会扫描manifests目录所有的镜像并build出registry目录放到与Kubefile同级的目录
   3. images/shim 目录放文件主要存储一些额外的镜像列表并build出registry目录放到与Kubefile同级的目录
   4. 如果需要模板，在etc、charts、manifests放一些*.tmpl  结尾的文件可以被sealos run 环境变量渲染后去掉tmpl ，比如渲染之前是aa.yaml.tmpl 渲染后aa.yaml 使用需要注意文件名不要与现有的文件冲突
   5. registry必须放在与Kubefile同级的目录否则无法拷贝到master0的私有仓库,制作镜像也需要注意下。不要把registry存放到chart里否则helm扫描慢导致OOM https://github.com/labring/sealos/issues/1545

##### APP集群镜像

主要是构建应用镜像，使用GitHub action,会同时出amd64和arm64架构


##### 配置集群镜像

主要是构建配置镜像，使用GitHub action，没有容器镜像不区分架构，一般是一些脚本相关的配置或者覆盖默认的配置镜像


##### Docker镜像

主要是构建容器镜像，使用GitHub action，会同时出amd64和arm64架构，暂时不支持Run命令，使用buildah进行的build所以没有做Run的支持


##### 大APP集群镜像

主要是构建应用镜像，使用阿里云主机构建,只会出amd64架构


##### 集群镜像手动构建

把你要收到更新的集群镜像放到 `.github/schedule/part1.txt` 主要是一些latest的镜像需要手动操作


##### 支持的命令

- /imagebuild_k8s 构建k8s镜像
  - /single_imagebuild_k8s_part1
  - /single_imagebuild_k8s_part2
  - /single_imagebuild_k8s_part3
- /imagebuild_configs 构建配置
- /imagebuild_apps 构建应用
- /imagebuild_docker_k8s 构建k8s基于docker
- /imagebuild_dockerimages 构建docker镜像
- /imagebuild_hosted 构建大APP镜像

##### 构建好镜像后后需要在集群内部执行的命令

```
// 这里用docker.io/labring/user-controller:dev举例子，运行请更新自己构建的镜像
sealos rmi -f docker.io/labring/user-controller:dev
sealos run -f docker.io/labring/user-controller:dev
```
如果出现这个报错
```
The ClusterRoleBinding "user-manager-rolebinding" is invalid: roleRef: Invalid value: rbac.RoleRef{APIGroup:"rbac.authorization.k8s.io", Kind:"ClusterRole", Name:"user-manager-role"}: cannot change roleRef
```
使用kubectl get clusterrolebinding 查看，删除后再sealos run-f 创建就没有问题了