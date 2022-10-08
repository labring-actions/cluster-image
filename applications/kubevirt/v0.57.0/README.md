## Overview

**[KubeVirt](https://kubevirt.io/)** is a virtual machine management add-on for Kubernetes. The aim is to provide a common ground for virtualization solutions on top of Kubernetes.

## Build

```shell
sealos build -f Dockerfile -t labring/kubevirt:v0.57.0 .
```

## Prerequisites

Official docs：https://kubevirt.io/user-guide/operations/installation/#requirements

## Quickstart

Run kubevirt and kubevirt cdi.

```shell
sealos run labring/kubevirt:v0.57.0
```

Create a vm

```shell
kubectl apply -f https://kubevirt.io/labs/manifests/vm.yaml
```

Start vm

```shell
virtctl start testvm
```

Verify vm status

```shell
kubectl get vmis
```

SSH connect to vm

```shell
virtctl console testvm
```
