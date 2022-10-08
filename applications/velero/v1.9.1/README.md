## Overview

[velero](https://velero.io/) gives you tools to back up and restore your Kubernetes cluster resources and persistent volumes. 

## Build

```shell
sealos build -f Dockerfile -t labring/velero:v1.9.1 .
```

## Prerequisites

Create minio storage out of kubernetes cluster, here is an example run standalone minio on node `192.168.72.15`  with docker.

```shell
docker run -d --name minio \
  --restart always \
  -p 9000:9000 \
  -p 9001:9001 \
  -e "MINIO_ROOT_USER=minio" \
  -e "MINIO_ROOT_PASSWORD=minio123" \
  -v /data/minio/data:/data \
  minio/minio server /data --console-address ":9001"
```

## Quickstart

Install velero to kubernetes cluster.

```shell
sealos run labring/velero:v1.9.1
```

## Run backup

1、create minio credentials


```
cat >credentials-velero<<EOF
[default]
aws_access_key_id = minio
aws_secret_access_key = minio123
EOF
```

2、create minio secrets


```
kubectl -n velero create secret generic velero-credentials \
  --from-file=minio=./credentials-velero
```

3、create backup location


```
velero backup-location create default \
  --provider aws \
  --bucket velero-backups \
  --credential=velero-credentials=minio \
  --config s3Url=http://192.168.72.15:9000,region=us-east-1,s3ForcePathStyle="true"
```

4、create backup jobs for postgresql, this will backup postgresql and it's persistent volumes.


```
velero backup create postgres-backup --include-namespaces postgres --default-volumes-to-restic
```

## recover backup

If you want recover backup to another cluser ,you should install velero and create a same backup location in that cluster.


```
velero restore create --from-backup postgres-backup --wait
```


