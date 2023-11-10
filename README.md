# cluster-image

Sealos 在 dockerhub 中的镜像使用 `github action` 自动构建，每个人都可以通过创建 github ISSUE 来触发构建任务，在ISSUE中通过`支持的命令`结合参数构建需要的镜像和版本，支持的版本请参考应用官方网站、helm 仓库或 github release 页面。

- DockerHub镜像仓库：[dockerhub](https://hub.docker.com/u/labring)
- 所有的镜像清单列表：[cluster-image-docs](https://github.com/labring-actions/cluster-image-docs)

## ISSUE创建方法

按不同的镜像类型，创建不同的ISSUE:

| 镜像类型                | ISSUE链接                                                    |
| ----------------------- | ------------------------------------------------------------ |
| APP集群镜像             | :green_circle: [点击创建ISSUE](https://github.com/labring/cluster-image/issues/new?assignees=&labels=&template=autobuild-apps.md&title=【Auto-build】helm) |
| Docker镜像(暂不支持Run) | :green_circle: [点击创建ISSUE](https://github.com/labring/cluster-image/issues/new?assignees=&labels=&template=autobuild-docker-apps.md&title=【Auto-build】cri) |
| 大APP集群镜像           | :green_circle: [点击创建ISSUE](https://github.com/labring/cluster-image/issues/new?assignees=&labels=&template=autobuild-hosted.md&title=【Auto-build】athenaserving) |

以构建新的nginx集群镜像为例。

由于社区已在`application`目录贡献了nginx构建脚本的实现，只需在ISSUE里搜索标题`【Auto-build】nginx`，在评论框输入以下指令，结合镜像名称（固定）和镜像版本（与官方一致），即可构建出新版本的nginx集群镜像，构建完成后会自动上传至DockerHub。

```bash
/imagebuild_apps nginx 1.23.1
```

## 镜像文件目录结构

镜像配置存放位置及目录结构如下：

```yaml
├── applications                # 所有应用
│   ├── apisix                  # 应用名称
│   │   ├── latest              # 应用版本
│   │   │   ├── entrypoint.sh   # 安装脚本
│   │   │   ├── init.sh         # 依赖下载
│   │   │   └── Kubefile        # 镜像文件
│   │   └── README.md           # 使用说明
│   ├── argocd
│   │   ├── latest
│   │   │   ├── entrypoint.sh
│   │   │   ├── init.sh
│   │   │   └── Kubefile
│   │   └── README.md
```

**如何构建?**

1. 匹配规则：如果ISSUE传递的版本参数匹配`applications/<应用名称>`下的`<应用版本>`，则执行`<应用版本>`目录中的`init.sh`脚本以及上下文进行构建，否则默认执行`latest`目录下的`init.sh`脚本以及上下文进行构建。
2. `init.sh`：内容根据实际需求，一般是需要下载一些helm chart、yaml文件以及不同架构的二进制文件，比如helm、kubectl-minio相关。
3. `Kubefile`：构建配置文件，支持 Docker/Kubefile 名称。
4. 构建规则及默认目录结构
   * `charts`：该目录存放集群镜像需要的helm chart，sealos根据扫描的chart 解析镜像清单，build出registry目录放到与Kubefile同级的目录。
   * `manifests` ：该目录存放一些yaml文件，sealos会扫描manifests目录所有的镜像并build出registry目录放到与Kubefile同级的目录。
   * `images/shim` ：该目录主要存储一些额外的镜像列表，并build出registry目录放到与Kubefile同级的目录。
   * `opt`：该目录存放一些二进制文件，比如helm、kubectl-minio等。
   * `templates`：模板渲染功能，如果需要模板，在etc、charts、manifests放一些 `*.tmpl` 结尾的文件可以被sealos run 环境变量渲染后去掉tmpl，比如渲染之前是`aa.yaml.tmpl` 渲染后 `aa.yaml` ，使用需要注意文件名不要与现有的文件冲突。
   * `registry`：该目录必须放在与Kubefile同级的目录，否则无法拷贝到master0的私有仓库，制作镜像也需要注意下。不要把registry存放到charts里，否则helm扫描慢导致OOM [labring/sealos#1545](https://github.com/labring/sealos/issues/1545)。

## 镜像类型

| 镜像类型         | 说明                                                         |
| ---------------- | ------------------------------------------------------------ |
| APP 集群镜像     | 主要是构建应用镜像，使用GitHub action,会同时构建出amd64和arm64架构 |
| Docker 镜像      | 主要是构建容器镜像，使用GitHub action，会同时构建出amd64和arm64架构，暂时不支持Run命令，使用buildah进行的build所以没有做Run的支持 |
| 大 APP 集群镜像  | 主要是构建应用镜像，使用阿里云主机构建,只会出amd64架构       |
| 集群镜像手动构建 | 把你要收到更新的集群镜像放到 `.github/schedule/part1.txt` 主要是一些latest的镜像需要手动操作 |

## 支持的命令

| 命令                       | 说明                                                         |
| -------------------------- | ------------------------------------------------------------ |
| `/imagebuild_k8s`          | `/single_imagebuild_k8s_part1`<br>`/single_imagebuild_k8s_part2`<br>`/single_imagebuild_k8s_part3` |
| `/imagebuild_configs`      | 构建配置                                                     |
| `/imagebuild_apps`         | 构建应用                                                     |
| `/imagebuild_docker_k8s`   | 构建k8s基于docker                                            |
| `/imagebuild_dockerimages` | 构建docker镜像                                               |
| `/imagebuild_hosted`       | 构建大APP镜像                                                |

## ROADMAP

- 拆分镜像构建（CRI和kubernetes拆分）
- 优化镜像流程,全部使用模板替换
- K3S/K0S

## 如何贡献

贡献流程如下：

- 参考 `application` 路径下其他应用的实现逻辑，编写自己应用的 `init.sh` 脚本、`Kubefile`以及`entrypoint.sh`。
- 提出PR，合并代码到github cluster-image仓库。
- 创建ISSUE，并执行构建，构建成功后镜像将自动推送到官方 dockerhub 仓库。
- 拉取镜像到本地，使用 selaos run 命令安装运行应用。
