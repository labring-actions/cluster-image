# kube-ovn

Kube-OVN, a CNCF Sandbox Project, bridges the SDN into Cloud Native. It offers an advanced Container Network Fabric for Enterprises with the most functions, extreme performance and the easiest operation.

## Prerequisites

- Kubernetes (depends on the app requirements)
- sealos v4.x

## Installing the app

To install the app with sealos run  command:

```bash
sealos run docker.io/labring/kube-ovn:v1.11.3
```

These commands deploy kube-ovn with install.sh to the Kubernetes cluster，list app using:

```bash
kubectl -n kube-system get pods
```

## Custome configuraton

Custome  kube-ovn config,

**method1**
```bash
sealos run docker.io/labring/kube-ovn:v1.11.3 \
  -e IFACE="eth.*,en.*" \
  -e SVC_CIDR="10.96.0.0/22" \
  -e POD_CIDR="100.64.0.0/10" \
  -e POD_GATEWAY="100.64.0.1" \
  -e JOIN_CIDR="20.65.0.0/16"
```
**method2**

create config-file
```
$ vim kube-ovn-config.yaml
apiVersion: apps.sealos.io/v1beta1
kind: Config
metadata:
  name: kube-ovn
spec:
  path: scripts/kube-ovn.env
  match: docker.io/labring/kube-ovn:v1.11.3
  strategy: append
  data: |
    SVC_CIDR="10.96.0.0/22"
    POD_CIDR="100.64.0.0/10"
    POD_GATEWAY="100.64.0.1"
    JOIN_CIDR="20.65.0.0/16"
```
run with config-file
```
selaos run docker.io/labring/kube-ovn:v1.11.3 --config-file=kube-ovn-config.yaml
```

Warn: The kube-ovn `POD_CIDR` must same with ClusterConfiguration, the default podSubnet of sealos is `100.64.0.0/10`, so do not change `POD_CIDR` if you are not custome `networking.podSubnet`  of ClusterConfiguration.

All support env: https://github.com/kubeovn/kube-ovn/blob/master/dist/images/install.sh

Check pod ip

```shell
root@ubuntu:~# kubectl -n kube-system get pods | grep kube-ovn
kube-ovn-cni-8pmbc                     1/1     Running   0             6d22h
kube-ovn-cni-dwdjv                     1/1     Running   0             6d22h
kube-ovn-cni-hqv57                     1/1     Running   0             6d22h
kube-ovn-controller-55c778d944-4kk8l   1/1     Running   0             3d6h
kube-ovn-controller-55c778d944-m8nk2   1/1     Running   0             6d22h
kube-ovn-controller-55c778d944-tfjsl   1/1     Running   0             3d6h
kube-ovn-monitor-9754c455c-h9jgh       1/1     Running   0             6d22h
kube-ovn-pinger-46c8r                  1/1     Running   0             6d22h
kube-ovn-pinger-5287h                  1/1     Running   0             6d22h
kube-ovn-pinger-wwvc9                  1/1     Running   0             6d22h
```

## Uninstalling the app

To uninstall/delete the `kube-ovn` app:

```bash
sealos run docker.io/labring/kube-ovn:v1.11.3 -e uninstall=true
```

The command removes all the resource associated with the installtion.
