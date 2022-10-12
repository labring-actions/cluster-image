---
name: 构建Kubernetes集群镜像
about: 根据分支目录构建集群镜像并推送到镜像仓库
title: '【Auto-build】kubernetes'
assignees: ''

---

```
Usage:
   /imagebuild_kube [sealosVersion]             # all containerd + all docker (increment)
   /imagebuild_k8s [sealosVersion]              # all containerd
   /imagebuild_docker_k8s [sealosVersion]       # all docker
   /single_imagebuild_k8s_part1 [sealosVersion]        # containerd for part1
   /single_imagebuild_docker_k8s_part1 [sealosVersion] # docker for part1
Example:
   /imagebuild_kube 4.1.3
   /imagebuild_k8s 4.1.3
   /imagebuild_docker_k8s 4.1.3
   /single_imagebuild_k8s_part1 4.1.3
   /single_imagebuild_docker_k8s_part1 4.1.3
```
