### rootfs
```
.
├── Kubefile
├── Metadata
├── README.md
├── bin
│   ├── conntrack
│   ├── kubeadm
│   ├── kubectl
│   └── kubelet
├── cri
│   ├── cri-containerd-linux.tar.gz
│   ├── crictl
│   ├── image-cri-shim
│   ├── lib64
│   │   ├── libseccomp.so.2
│   │   └── libseccomp.so.2.3.1
│   └── nerdctl
├── etc
│   ├── 10-kubeadm.conf
│   ├── Clusterfile
│   ├── calico.replace.yaml
│   ├── calico.yaml
│   ├── config.toml
│   ├── config.yml
│   ├── containerd.service
│   ├── crictl.yaml
│   ├── hosts.toml
│   ├── image-cri-shim.service
│   ├── kubeadm-config.yaml
│   ├── kubelet.service
│   └── registry_config.yml
├── images
│   └── registry.tar
├── registry
│   └── docker
│       └── registry
├── scripts
│   ├── clean-containerd.sh
│   ├── clean-kube.sh
│   ├── clean-registry.sh
│   ├── clean-shim.sh
│   ├── clean.sh
│   ├── init-containerd.sh
│   ├── init-kube.sh
│   ├── init-registry.sh
│   ├── init-shim.sh
│   ├── init.sh
│   ├── kubelet-post-stop.sh
│   ├── kubelet-pre-start.sh
│   └── logger.sh
└── statics
    └── audit-policy.yml
```

配置文件 config.yaml,calico.replace.yaml,Metadata

```yaml
CNI:
  Type: calico
  Version: v3.19.1
HubDomain: sealos.hub
Images:
- ghcr.io/labring/lvscare:v1.1.3-beta.2
- docker.io/calico/cni:v3.19.1
- docker.io/calico/pod2daemon-flexvol:v3.19.1
- docker.io/calico/node:v3.19.1
- docker.io/calico/kube-controllers:v3.19.1
- k8s.gcr.io/kube-apiserver:v1.22.0
- k8s.gcr.io/kube-controller-manager:v1.22.0
- k8s.gcr.io/kube-scheduler:v1.22.0
- k8s.gcr.io/kube-proxy:v1.22.0
- k8s.gcr.io/pause:3.5
- k8s.gcr.io/etcd:3.5.0-0
- k8s.gcr.io/coredns/coredns:v1.8.4
```

calico replace

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: calico-replace
data:
  interface: "__INTERFACE__"
  ipip: "__IPIP__"
  cidr: "__CIDR__"
  mtu: "__MTU__"
```


init.sh 参数列表
1. /var/lib/containerd
2. sealos.hub
3. 5000
4. auth (docker没有这个参数)

init-registry.sh 参数列表
1. 5000
2. /var/lib/registry
3. /etc/registry
/etc/registry/registry_htpasswd
