# Calico

Cloud native networking and network security.

In this image, install the Tigera Calico operator and custom resource definitions using the Helm 3 chart. The Tigera operator provides lifecycle management for Calico exposed via the Kubernetes API defined as a custom resource definition.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- Helm 3.x.x

## Installing the app

```shell
$ sealos run docker.io/labring/calico:3.26.1
```

## Uninstalling the app

```shell
$ helm -n kube-system uninstall calico
```

## Configuration

1. Generate Clusterfile

```
sealos gen \
  labring/kubernetes:v1.27.3 \
  labring/helm:v3.12.3 \
  labring/calico:3.26.1 \
  --masters 192.168.72.31 \
  --passwd 123456 > Clusterfile
```

2. Custome calico configuration

```shell
$ cat Clusterfile
......
---
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
networking:
  podSubnet: 10.64.0.0/12
---
apiVersion: apps.sealos.io/v1beta1
kind: Config
metadata:
  name: calico
spec:
  path: charts/calico/values.yaml
  match: docker.io/labring/calico:3.26.1
  strategy: merge
  data: |
    installation:
      enabled: true
      kubernetesProvider: ""
      calicoNetwork:
        ipPools:
        - blockSize: 26
          cidr: 100.64.0.0/10
          encapsulation: IPIP
          natOutgoing: Enabled
          nodeSelector: all()
        nodeAddressAutodetectionV4:
          interface: "eth.*|en.*"
```

3. Install cluster and calico

```shell
$ sealos apply -f Clusterfile
```

4. Check installtion config

```shell
$ kubectl -n kube-system get Installation default -o yaml
```
