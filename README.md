# cluster-image

Sealos cluster image，也称为集群镜像，是 Sealos 工具的一个创新功能。该特性允许用户将 Kubernetes 云原生应用和插件打包成一个统一的 Docker 镜像，从而简化和标准化云原生生态下各种应用及插件的部署和管理。

Rootfs 相关的集群镜像请参考 [runtime项目](https://github.com/labring-actions/runtime)。

## 功能特性

1. :package: 统一封装: 集成 Kubernetes 应用和插件依赖的所需的所有资源，包括 YAML 文件、Helm charts、Docker 镜像和二进制文件。
2. :sparkles: 简化安装: 提供一键部署能力，通过单一的镜像，一键部署整个应用，大幅降低部署复杂性和时间。
3. :globe_with_meridians: 离线部署: 支持在没有网络连接的环境中部署集群镜像。
4. :wrench: 高度可定制: 支持用户按需定制化封装，满足不同环境和需求的部署。
5. :earth_africa: 多环境兼容: 适用于不同的运行环境，无论是在开发、测试还是生产环境，确保一致性和稳定性。
6. :arrows_counterclockwise: 快速迭代和版本更新  : 集群镜像中的应用大多以`helm upgrade --install`形式安装，便于版本快速迭代和升级。

## 镜像类型

**kubernetes 镜像：**

| 镜像地址                                    | 镜像名称            | 说明                     |
| :------------------------------------------ | :------------------ | :----------------------- |
| `docker.io/labring/kubernetes:<tag>`        | `kubernetes`        | 包含containerd容器运行时 |
| `docker.io/labring/kubernetes-docker:<tag>` | `kubernetes-docker` | 包含docker容器运行时     |
| `docker.io/labring/kubernetes-crio::<tag>`  | `kubernetes-crio`   | 包含crio-o容器运行时     |

**application 镜像：**

| 镜像地址                          | 镜像名称 | 说明            |
| --------------------------------- | -------- | --------------- |
| `docker.io/labring/helm:<tag>`    | helm     | helm二进制文件  |
| `docker.io/labring/calico:<tag>`  | calico   | calico网络插件  |
| `docker.io/labring/openebs:<tag>` | openebs  | openebs存储插件 |
| ......                            |          | ......          |

完整的镜像清单见以下链接：

- 镜像清单列表汇总：[cluster-image-docs](https://github.com/labring-actions/cluster-image-docs)
- DockerHub镜像仓库：[hub.dockerhub.com](https://hub.docker.com/u/labring)

## 构建方法

Sealos 在 dockerhub 中的镜像使用 `github action` 自动构建，社区用户可以通过创建 github ISSUE 来触发构建任务，在ISSUE中通过支持的指令结合参数构建需要的镜像和版本，版本参数请参考应用官方网站、helm 仓库或 github release 页面。

已贡献的镜像可直接点击跳转 Github ISSUE 进行新版本构建：:green_circle: [点击创建ISSUE](https://github.com/labring/cluster-image/issues/new?assignees=&labels=&template=autobuild-apps.md&title=【Auto-build】helm)。

以构建新的nginx集群镜像为例，由于社区已在`application`目录贡献了 nginx 构建脚本的实现，只需在ISSUE里搜索标题`【Auto-build】nginx`，在评论框输入以下指令，结合镜像名称（固定）和镜像版本（与官方一致），即可构建出新版本的nginx集群镜像，构建完成后会自动上传至DockerHub。

示例指令如下：

```bash
/imagebuild_apps nginx v1.23.1
```

### 项目结构

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

**构建规则说明：**

- 如果 ISSUE 传递的版本参数匹配`applications/<应用名称>`下的`<应用版本>`，则执行`<应用版本>`目录中的`init.sh`脚本以及该目录上下文进行构建；
- 如果未找到固定版本，版本信息将传递到`latest`目录下的`init.sh`脚本，并执行该脚本以及基于该目录上下文进行构建。

**目录结构说明：**

- `init.sh`：名称不可变，内容可自定义，一般是需要下载一些helm chart、yaml文件以及不同架构的二进制文件，比如helm、kubectl-minio相关；
- `Kubefile`：镜像构建配置文件，支持 Docker/Kubefile 名称；
- `entrypoint.sh`：名称及内容自定义，一般封装应用实际部署命令，例如kubectl apply 或 helm install等；

* `charts`：该目录存放集群镜像需要的helm chart，sealos根据扫描的chart 解析镜像清单，build出registry目录放到与Kubefile同级的目录；
* `manifests` ：该目录存放一些yaml文件，sealos会扫描manifests目录所有的镜像并build出registry目录放到与Kubefile同级的目录；
* `images/shim` ：该目录主要存储一些额外的镜像列表，例如手动创建`images_list.txt`，并build出registry目录放到与Kubefile同级的目录；
* `opt`：该目录存放一些二进制文件，比如helm、kubectl-minio等；
* `registry`：默认自动生成，该目录必须放在与Kubefile同级的目录，否则无法拷贝到master0的私有仓库，制作镜像也需要注意下。不要把registry存放到charts里，否则helm扫描慢导致OOM [labring/sealos#1545](https://github.com/labring/sealos/issues/1545)；
* 模板渲染：如果需要模板，在etc、charts、manifests放一些 `*.tmpl` 结尾的文件可以被`sealos run -e`环境变量渲染后去掉tmpl，比如渲染之前是`aa.yaml.tmpl` 渲染后 `aa.yaml` ，使用需要注意文件名不要与现有的文件冲突。

### ISSUE 支持的命令

Github ISSUE支持的命令清单如下：

| 命令                       | 说明                                   |
| -------------------------- | :------------------------------------- |
| `/imagebuild_apps`         | 构建集群应用镜像                       |
| `/imagebuild_dockerimages` | 构建标准docker镜像                     |
| `/imagesync`               | 同步镜像，有权限控制，只有机器人可操作 |

## ROADMAP

- wasm 镜像支持

## 如何贡献

贡献流程如下：

1. 参考 `application` 路径下其他应用的实现逻辑，编写自己应用的 `init.sh` 脚本、`Kubefile`以及`entrypoint.sh`。
2. 提出PR，合并代码到github cluster-image仓库。
3. 创建ISSUE，并执行构建，构建成功后镜像将自动推送到官方 dockerhub 仓库。
4. 拉取镜像到本地，使用 sealos run 命令安装运行应用。
