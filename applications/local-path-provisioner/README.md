## local-path-provisioner

[rancher local-path-provisioner](https://github.com/rancher/local-path-provisioner) dynamically provisioning persistent local storage with Kubernetes.

## Install

```shell
sealos run labring/local-path-provisioner:v0.0.23
```

Check pods status

```shell
root@ubuntu:~# kubectl -n local-path-storage get pods
NAME                                                         READY   STATUS    RESTARTS   AGE
local-path-storage-local-path-provisioner-54f975cc58-5bc96   1/1     Running   0          5m39s
```

Check storageclass

```shell
root@ubuntu:~# kubectl get sc
NAME                   PROVISIONER                                               RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local-path (default)   cluster.local/local-path-storage-local-path-provisioner   Delete          WaitForFirstConsumer   true                   5m47s
```

## Uninstall

```shell
helm -n local-path-storage uninstall local-path-storage
```

