### Build

Build command

```shell
sealos build -f Dockerfile -t registry.cn-qingdao.aliyuncs.com/labring/cilium:v1.12.0 .
```

helm charts

```shell
helm repo add cilium https://helm.cilium.io/
helm pull cilium/cilium --version=1.12.0 --untar -d charts/
```

Notes: Need some additional configuration

```shell
mv charts/cilium/values.yaml.tmpl{,.bak}
sed -i 's#useDigest: true#useDigest: false#g' charts/cilium/values.yaml
```

## Usage

Before install this cilium application，you have to meet some pre requirements，The most basic requirements is `Linux kernel>= 4.9.17`,suggest use ubuntu 22.04 LTS server which have a default kernel version of `5.15.0`.

1.Generate your own Clusterfile

```shell
sealos gen  \
  --masters 192.168.72.50 \
  --nodes 192.168.72.51,192.168.72.52 -p 123456 \
  labring/kubernetes:v1.24.3 \
  registry.cn-qingdao.aliyuncs.com/labring/cilium:v1.12.0 > Clusterfile
```

2.Add the follow kubeadm InitConfiguration to Clusterfile, cilium can replace kube-proxy,so we can skip install it for  kubernetes.

```yaml
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
skipPhases:
- addon/kube-proxy
```

And the Cluster file like this

```yaml
apiVersion: apps.sealos.io/v1beta1
kind: Cluster
metadata:
  creationTimestamp: null
  name: default
spec:
  hosts:
  - ips:
    - 192.168.72.50:22
    roles:
    - master
    - amd64
  - ips:
    - 192.168.72.51:22
    - 192.168.72.52:22
    roles:
    - node
    - amd64
  image:
  - labring/kubernetes:v1.24.3
  - registry.cn-qingdao.aliyuncs.com/labring/cilium:v1.12.0
  ssh:
    passwd: "123456"
    pk: /root/.ssh/id_rsa
    port: 22
    user: root
status: {}
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
skipPhases:
- addon/kube-proxy
```

3.Install kubernetes and cilium

```
sealos apply -f Clusterfile
```

Verify installion

```
root@node01:~# kubectl -n kube-system get pods
NAME                              READY   STATUS    RESTARTS   AGE
cilium-5sjzb                      1/1     Running   0          20m
cilium-ljhhb                      1/1     Running   0          20m
cilium-operator-768f5f7f9-5gs2x   1/1     Running   0          28m
coredns-6d4b75cb6d-4m46h          1/1     Running   0          28m
coredns-6d4b75cb6d-nv8gz          1/1     Running   0          28m
etcd-node01                       1/1     Running   0          28m
hubble-relay-596847d885-xkb9c     1/1     Running   0          19m
kube-apiserver-node01             1/1     Running   0          28m
kube-controller-manager-node01    1/1     Running   0          28m
kube-scheduler-node01             1/1     Running   0          28m
kube-sealyun-lvscare-node02       1/1     Running   0          28m
```

4. Verify the cilium status

```
root@node1:~# cilium status
    /¯¯\
 /¯¯\__/¯¯\    Cilium:         OK
 \__/¯¯\__/    Operator:       OK
 /¯¯\__/¯¯\    Hubble:         OK
 \__/¯¯\__/    ClusterMesh:    disabled
    \__/

Deployment        cilium-operator    Desired: 1, Ready: 1/1, Available: 1/1
DaemonSet         cilium             Desired: 3, Ready: 3/3, Available: 3/3
Deployment        hubble-relay       Desired: 1, Ready: 1/1, Available: 1/1
Containers:       cilium             Running: 3
                  hubble-relay       Running: 1
                  cilium-operator    Running: 1
Cluster Pods:     9/9 managed by Cilium
Image versions    cilium             quay.io/cilium/cilium:v1.12.0: 3
                  hubble-relay       quay.io/cilium/hubble-relay:v1.12.0@sha256:ca8033ea8a3112d838f958862fa76c8d895e3c8d0f5590de849b91745af5ac4d: 1
                  cilium-operator    quay.io/cilium/operator-generic:v1.12.0: 1
```

5. Run `connectivity-check` to test connectivity between pods

```
cilium hubble enable
hubble status
cilium hubble port-forward&

cilium connectivity test
```

6. Run sample app for test

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx
spec:
  selector:
    matchLabels:
      run: my-nginx
  replicas: 2
  template:
    metadata:
      labels:
        run: my-nginx
    spec:
      containers:
      - name: my-nginx
        image: nginx
        ports:
        - containerPort: 80
```

Expose with nodeport 

```
kubectl expose deployment my-nginx --type=NodePort --port=80
```