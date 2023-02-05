## Overview

Kube-vip is Kubernetes Control Plane Virtual IP and Load-Balancer.

sealos have a internal loadbalancer with IPVS VIP, the kube-vip provide a external loadbalancer with IPVS VIP.

Kube-vip allows you to connect to the kubernetes apiserver through the highly available vip address outside the cluster.

## Install

Enable control plane loadbalancer

```shell
sealos run labring/kube-vip:v0.5.8 \
  -e kube_vip_interface=ens160 \
  -e kube_vip_address=192.168.72.240
```

You must certs the VIP when connnect apiserver out of cluster.

```shell
sealos cert --alt-names 192.168.72.240
```

Get Pods status

```shell
root@node1:~# kubectl -n kube-system get pods -o wide |grep kube-vip
kube-vip-node1                  1/1     Running   0             23m   192.168.72.32    node1   <none>           <none>
kube-vip-node2                  1/1     Running   0             23m   192.168.72.33    node2   <none>           <none>
kube-vip-node3                  1/1     Running   0             23m   192.168.72.34    node3   <none>           <none>
```

Get vip status

```shell
root@node1:~# ip a show ens160
2: ens160: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:50:56:ad:ed:0e brd ff:ff:ff:ff:ff:ff
    altname enp3s0
    inet 192.168.72.32/24 brd 192.168.72.255 scope global ens160
       valid_lft forever preferred_lft forever
    inet 192.168.72.240/32 scope global ens160
       valid_lft forever preferred_lft forever
    inet6 fe80::250:56ff:fead:ed0e/64 scope link 
       valid_lft forever preferred_lft forever
```

Check ipvs rules for control plane loadbalance.

```shell
root@node1:~# ipvsadm -Ln
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
TCP  192.168.72.240:6443 rr
  -> 192.168.72.32:6443           Local   1      0          0         
  -> 192.168.72.33:6443           Local   1      0          0         
  -> 192.168.72.34:6443           Local   1      0          0      
```

ExcludeCIDRs for vip

```yaml
root@node1:~# kubectl -n kube-system edit cm kube-proxy
      excludeCIDRs:
      - 10.103.97.2/32
      - 192.18.72.240/32
```

## Enable service loadbalancer

This `svc_enable` env will install `kube-vip-cloud-provider` for loadbalancer type service.

The `cidr_global` or `range_global` env assign IP addresses to service of type loadbalance.

```shell
sealos run labring/kube-vip:v0.5.8 \
  -e kube_vip_interface=ens160 \
  -e kube_vip_address=192.168.72.240 \
  -e svc_enable=true \
  #-e cidr_global=192.168.72.200/29 \
  -e range_global=192.168.72.150-192.168.72.190
```

## Deploy when installing cluster

Add this to Clusterfile

```yaml
......
---
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta2
apiServer:
  certSANs:
  - "192.168.72.240"
---
kind: KubeProxyConfiguration
apiVersion: kubeproxy.config.k8s.io/v1alpha1
ipvs:
  excludeCIDRs:
  - 192.168.72.240/32
```

Install cluster with kube-vip

```shell
sealos apply -f Clusterfile -e kube_vip_interface=ens160 -e kube_vip_address=192.168.72.240
```

## Uninstall

```shell
rm -rf /etc/kubernetes/manifests/kube-vip.yaml
```
