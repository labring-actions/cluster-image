## Overview

Multus CNI enables attaching multiple network interfaces to pods in Kubernetes.

## Install

Default installation.

```shell
sealos run docker.io/labring/multus-cni:v4.0.1
```

Get the pods status

```shell
$ kubectl -n kube-system get pods -l app=multus
NAME                   READY   STATUS    RESTARTS   AGE
kube-multus-ds-jxqvt   1/1     Running   0          2m49s
```

Then refer to official [quickstart](https://github.com/k8snetworkplumbingwg/multus-cni/blob/master/docs/quickstart.md#creating-additional-interfaces) using Multus CNI to create Kubernetes pods with multiple interfaces. 

You need to install additional [cni-plugin](https://github.com/containernetworking/plugins) before using Multus CNI, this image will install it by default.

## Uninstall

```shell
sealos run docker.io/labring/multus-cni:v4.0.1 -e uninstall=true
```
