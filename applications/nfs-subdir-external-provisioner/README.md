## Usage

Run sample nfs server out of kubernetes cluster

```shell
docker run -d --name nfs-server \
    --privileged \
    --restart always \
    -p 2049:2049 \
    -v /nfs-share:/nfs-share \
    -e SHARED_DIRECTORY=/nfs-share \
    itsthenetwork/nfs-server-alpine:latest
```

Install nfs-client in all kubernetes cluster nodes.

```shell
apt install -y nfs-common
```

Intall nfs-subdir-external-provisioner, if use docker install nfs server ,just keep NFS_PATH as `/`.

```shell
sealos run labring/nfs-subdir-external-provisioner:v4.0.17 --env NFS_SERVER=192.168.72.15 --env NFS_PATH=/
```

Notes: only support `NFS_SERVER`and `NFS_PATH` env.

Get storageclass

```shell
kubectl get sc
```

