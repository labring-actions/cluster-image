## Overview

KubeSphere is a distributed operating system for cloud-native application management, using Kubernetes as its kernel. It provides a plug-and-play architecture, allowing third-party applications to be seamlessly integrated into its ecosystem.

## Prepare a cluster

Prepare clusterfile

```
apiVersion: apps.sealos.io/v1beta1
kind: Cluster
metadata:
  name: default
spec:
  hosts:
  - ips:
    - 192.168.10.10
    - 192.168.10.11
    - 192.168.10.12
    roles:
    - master
    - amd64
  image:
  - docker.io/labring/kubernetes:v1.26.7-4.3.0
  - registry.cn-hongkong.aliyuncs.com/labring/helm:v3.12.0
  - registry.cn-hongkong.aliyuncs.com/labring/flannel:v0.22.0
  - registry.cn-hongkong.aliyuncs.com/labring/openebs:v3.4.0
  ssh:
    passwd: 123456
    pk: ~/.ssh/id_rsa
    port: 22
    user: root
```

Apply clusterfile

```
sealos apply -f Clusterfile
```

Notes:  untaint master nodes first.

```
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```

## Install kubesphere

Prerequisites: You should check the official document of kubesphere to confirm which versions of kubernetes are compatible with kubesphere.

```shell
sealos run hub.sealos.cn/labring/kubesphere:v3.4.0
```

Check pods status

```shell
root@node1:~# kubectl get pods -A
NAMESPACE                      NAME                                               READY   STATUS      RESTARTS      AGE
kube-flannel                   kube-flannel-ds-85gnb                              1/1     Running     1 (41h ago)   2d
kube-flannel                   kube-flannel-ds-p6wld                              1/1     Running     1 (41h ago)   2d
kube-flannel                   kube-flannel-ds-ssrfw                              1/1     Running     2 (41h ago)   2d
kube-system                    coredns-787d4945fb-g5rnp                           1/1     Running     0             37h
kube-system                    coredns-787d4945fb-ngwzt                           1/1     Running     0             37h
kube-system                    etcd-node1                                         1/1     Running     2 (41h ago)   2d
kube-system                    etcd-node2                                         1/1     Running     1 (41h ago)   2d
kube-system                    etcd-node3                                         1/1     Running     2 (41h ago)   2d
kube-system                    kube-apiserver-node1                               1/1     Running     2 (41h ago)   2d
kube-system                    kube-apiserver-node2                               1/1     Running     3 (41h ago)   2d
kube-system                    kube-apiserver-node3                               1/1     Running     5 (41h ago)   2d
kube-system                    kube-controller-manager-node1                      1/1     Running     3 (41h ago)   2d
kube-system                    kube-controller-manager-node2                      1/1     Running     2 (41h ago)   2d
kube-system                    kube-controller-manager-node3                      1/1     Running     3 (41h ago)   2d
kube-system                    kube-proxy-ckt6p                                   1/1     Running     2 (41h ago)   2d
kube-system                    kube-proxy-g58nk                                   1/1     Running     1 (41h ago)   2d
kube-system                    kube-proxy-vdqhm                                   1/1     Running     1 (41h ago)   2d
kube-system                    kube-scheduler-node1                               1/1     Running     3 (41h ago)   2d
kube-system                    kube-scheduler-node2                               1/1     Running     2 (41h ago)   2d
kube-system                    kube-scheduler-node3                               1/1     Running     4 (41h ago)   2d
kube-system                    snapshot-controller-0                              1/1     Running     1 (41h ago)   47h
kubesphere-controls-system     default-http-backend-864f4f5c6b-fl2c5              1/1     Running     1 (41h ago)   47h
kubesphere-controls-system     kubectl-admin-c6988866d-5cjtj                      1/1     Running     1 (41h ago)   47h
kubesphere-monitoring-system   alertmanager-main-0                                2/2     Running     2 (41h ago)   47h
kubesphere-monitoring-system   alertmanager-main-1                                2/2     Running     5 (41h ago)   47h
kubesphere-monitoring-system   alertmanager-main-2                                2/2     Running     2 (41h ago)   47h
kubesphere-monitoring-system   kube-state-metrics-5f77fc8f6d-h4vfp                3/3     Running     3 (41h ago)   47h
kubesphere-monitoring-system   node-exporter-kk9h6                                2/2     Running     4 (41h ago)   47h
kubesphere-monitoring-system   node-exporter-mrt7f                                2/2     Running     2 (41h ago)   47h
kubesphere-monitoring-system   node-exporter-nn67n                                2/2     Running     2 (41h ago)   47h
kubesphere-monitoring-system   notification-manager-deployment-f86fdf45d-6fthp    2/2     Running     2 (41h ago)   47h
kubesphere-monitoring-system   notification-manager-deployment-f86fdf45d-k6fkv    2/2     Running     4 (41h ago)   47h
kubesphere-monitoring-system   notification-manager-operator-7b8dcfd75c-cttj6     2/2     Running     2 (41h ago)   47h
kubesphere-monitoring-system   prometheus-k8s-0                                   2/2     Running     5 (41h ago)   47h
kubesphere-monitoring-system   prometheus-k8s-1                                   2/2     Running     2 (41h ago)   47h
kubesphere-monitoring-system   prometheus-operator-845b8fb9df-hcwgk               2/2     Running     2 (41h ago)   47h
kubesphere-system              ks-apiserver-5cfc56fd46-mj46j                      1/1     Running     1 (41h ago)   47h
kubesphere-system              ks-console-d854488f7-gvwdg                         1/1     Running     1 (41h ago)   47h
kubesphere-system              ks-controller-manager-57584fdbf6-hbvt9             1/1     Running     1 (41h ago)   47h
kubesphere-system              ks-installer-758d459599-trz92                      1/1     Running     1 (41h ago)   47h
openebs                        openebs-localpv-provisioner-74d59556f6-5xvwv       1/1     Running     1 (41h ago)   2d
```

## Login kubesphere UI

Default username/password is `admin/P@88w0rd`

```shell
http://192.168.1.10:30880
```
