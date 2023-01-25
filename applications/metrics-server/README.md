# Kubernetes Metrics Server

[Metrics Server](https://github.com/kubernetes-sigs/metrics-server/) is a scalable, efficient source of container resource metrics for Kubernetes built-in autoscaling pipelines.

## Install

```shell
sealos run labring/metrics-server:v0.6.2
```

Get nodes metrics 

```
root@ubuntu:~# kubectl top nodes
NAME     CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%   
ubuntu   271m         6%     5695Mi          72%       
```

Get pods metrics 

```
root@ubuntu:~# kubectl top pods
NAME                          CPU(cores)   MEMORY(bytes)   
samplepod                     0m           0Mi             
test-nginx-857b99fd65-vm4q2   1m           7Mi
```

## Uinstall

```shell
helm -n kube-system uninstall metrics-server
```
