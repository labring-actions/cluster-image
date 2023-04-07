---
name: 构建Docker集群镜像
about: 根据分支目录构建Docker镜像并推送到镜像仓库
title: '【Auto-build】helm'
assignees: ''

---

```
Usage:
   /imagebuild_dockerimages appName appVersion
Available Args:
   appName:  current app dir
   appVersion: current app version
   buildArgs:  build args, split by ','

Example:
   /imagebuild_dockerimages helm v3.8.2 Key1=Value1,Key2=Value2
```
