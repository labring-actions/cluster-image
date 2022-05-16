---
name: 构建应用集群镜像
about: 根据分支目录构建集群镜像并推送到镜像仓库
title: '【Auto-build】oci-helm'
assignees: ''

---

```
Usage:
   /imagebuild_apps appName appVersion appDirName
Available Args:
   appName:  current app dir
   appVersion: current app version
   appDirName: current app dir

Example:
   /imagebuild_apps helm v3.8.2 default
```
