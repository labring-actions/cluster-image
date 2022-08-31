## Build

Build command

```shell
sealos build -f Dockerfile -t labring/flannel:v1.19.1 .
```

manifests

```shell
wget https://raw.githubusercontent.com/flannel-io/flannel/v0.19.1/Documentation/kube-flannel.yml
```

Notes: Need some additional configuration

1.Change podcidr

```shell
sed -i s#10.244.0.0/16#100.64.0.0/10#g manifests/kube-flannel.yml 
```

2.Fix missing CNI plugins with add initContainers named `install-cni-plugin-sealos`
```yaml
      - name: install-cni-plugins
        image: docker.io/labring/docker-cni-plugins:v1.1.1
        command:
          - cp
        args:
          - -auv
          - /cni-plugins/*
          - /opt/cni/bin/
        volumeMounts:
          - name: cni-plugin
            mountPath: /opt/cni/bin
```

## Usage

install flannle app,example:
```shell
sealos run  \
  --masters 192.168.72.50 \
  --nodes 192.168.72.51,192.168.72.52 -p 123456 \
  labring/kubernetes:v1.24.4 \
  labring/flannel:v1.19.1
```

2. verify pods status

```shll
root@node01:~# kubectl -n kube-flannel get pods
NAME                    READY   STATUS    RESTARTS   AGE
kube-flannel-ds-2l2rq   1/1     Running   0          17h
kube-flannel-ds-brkj7   1/1     Running   0          17h
kube-flannel-ds-r427q   1/1     Running   0          17h
```
