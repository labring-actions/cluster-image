# Flannel

Flannel is a simple and easy way to configure a layer 3 network fabric designed for Kubernetes.

## Prerequisites

- Kubernetes (depends on the app requirements)
- sealos v4.x
- helm v3.x

## Installing the app

To install the app with sealos run  command:

```bash
sealos run docker.io/labring/flannel:v0.21.4
```

These commands deploy flannel with helm to the Kubernetes cluster，list app using:

```bash
helm -n kube-flannel ls
```

## Uninstalling the app

To uninstall/delete the `flannel` app:

```bash
sealos run docker.io/labring/flannel:v0.21.4 -e uninstall=true
```

The command removes all the resource associated with the installtion.

## Custome configuraton

Custome  flannel podCidr or backend.

```bash
sealos run docker.io/labring/flannel:v0.21.4 \
  -e POD_CIDR="100.64.0.0/10" \
  -e BACKEND="vxlan"
```

Warn: The flannel `POD_CIDR` must same with ClusterConfiguration, the default podSubnet of sealos is `100.64.0.0/10`, so do not change `POD_CIDR` if you are not custome `networking.podSubnet`  of ClusterConfiguration.

Here is a sample Clusterfile to [custome podSubnet and serviceSubnet](https://www.sealyun.com/docs/getting-started/customize-cluster):

```bash
sealos gen \
  hub.sealos.cn/labring/kubernetes:v1.25.6 \
  hub.sealos.cn/labring/helm:v3.11.0 \
  hub.sealos.cn/labring/flannel:v0.21.4 \
  --masters 192.168.10.10 -p 123456 > Clusterfile
```

Custome Clusterfile:

```yaml
apiVersion: apps.sealos.io/v1beta1
kind: Cluster
metadata:
  creationTimestamp: null
  name: default
spec:
  hosts:
  - ips:
    - 192.168.72.35:22
    roles:
    - master
    - amd64
  image:
  - hub.sealos.cn/labring/kubernetes:v1.25.6
  - hub.sealos.cn/labring/helm:v3.11.0
  - registry.cn-shenzhen.aliyuncs.com/cnmirror/flannel:v0.21.4
  ssh:
    passwd: "123456"
    pk: /root/.ssh/id_rsa
    port: 22
status: {}

---
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
networking:
  podSubnet: 10.244.0.0/16
  serviceSubnet: "10.96.0.0/22"
---
apiVersion: apps.sealos.io/v1beta1
kind: Config
metadata:
  name: flannel
spec:
  path: charts/flannel/values.yaml
  strategy: merge
  data: |
    podCidr: "10.244.0.0/16"
    flannel:
      backend: "vxlan"
```

Apply Clusterfile

```
sealos apply -f Clusterfile
```

Check podCidr

```
root@ubuntu:~# kubectl -n kube-system get cm kubeadm-config -o yaml |grep Subnet
      podSubnet: 10.244.0.0/16
      serviceSubnet: 10.96.0.0/22
```

Check pod ip

```
root@ubuntu:~# kubectl get pods -A -o wide
NAMESPACE      NAME                             READY   STATUS    RESTARTS   AGE   IP              NODE     NOMINATED NODE   READINESS GATES
kube-flannel   kube-flannel-ds-xfdqm            1/1     Running   0          46s   192.168.72.35   ubuntu   <none>           <none>
kube-system    coredns-565d847f94-95dr5         1/1     Running   0          46s   10.244.0.3      ubuntu   <none>           <none>
kube-system    coredns-565d847f94-lmvzm         1/1     Running   0          46s   10.244.0.2      ubuntu   <none>           <none>
kube-system    etcd-ubuntu                      1/1     Running   6          62s   192.168.72.35   ubuntu   <none>           <none>
kube-system    kube-apiserver-ubuntu            1/1     Running   6          61s   192.168.72.35   ubuntu   <none>           <none>
kube-system    kube-controller-manager-ubuntu   1/1     Running   2          61s   192.168.72.35   ubuntu   <none>           <none>
kube-system    kube-proxy-7jvgg                 1/1     Running   0          46s   192.168.72.35   ubuntu   <none>           <none>
kube-system    kube-scheduler-ubuntu            1/1     Running   6          63s   192.168.72.35   ubuntu   <none>           <none>
```

