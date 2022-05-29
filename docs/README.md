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
