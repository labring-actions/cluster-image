# kubectl-df-pv

kubectl plugin - giving admins df (disk free) like utility for persistent volumes.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- kubectl

## Installing the app

```shell
$ sealos run docker.io/labring/kubectl-df-pv:v0.3.0
```

## Usage

Get all namespace pv usage

```shell
$ kubectl dfpv

 PV NAME                                   PVC NAME                               NAMESPACE    NODE NAME  POD NAME                                 VOLUME MOUNT NAME   SIZE   USED   AVAILABLE  %USED  IUSED    IFREE      %IUSED 
 pvc-74892286-f4c9-4b5b-8308-3edc62f079d6  gitea-shared-storage                   gitea        ubuntu     gitea-9cf775dfb-cm6lb                    data                296Gi  102Gi  194Gi      34.38  1073874  154608942  0.69   
 pvc-9b0696d2-49a9-4a3f-81d8-18904b40d370  repo-data-gitlab-gitaly-0              gitlab       ubuntu     gitlab-gitaly-0                          repo-data           296Gi  102Gi  194Gi      34.38  1073874  154608942  0.69   
 pvc-2465371e-4df8-40ce-aa21-27c908b7cd05  harbor-jobservice                      harbor       ubuntu     harbor-jobservice-7bdddbb666-4zs9h       job-logs            296Gi  102Gi  194Gi      34.38  1073874  154608942  0.69   
 pvc-a06d5783-92dc-4fe5-9fdd-7ee4a601a82f  redis-data-gitlab-redis-master-0       gitlab       ubuntu     gitlab-redis-master-0                    redis-data          296Gi  102Gi  194Gi      34.39  1073874  154608942  0.69   
 pvc-a2a18e3d-cb91-42df-828b-b909effb116b  redis-data-gitea-redis-cluster-2       gitea        ubuntu     gitea-redis-cluster-2                    redis-data          296Gi  102Gi  194Gi      34.38  1073874  154608942  0.69   
 pvc-8aa5fdc4-0015-4e01-aa28-432a2c90fb76  redis-data-gitea-redis-cluster-4       gitea        ubuntu     gitea-redis-cluster-4                    redis-data          296Gi  102Gi  194Gi      34.38  1073875  154608941  0.69   
 pvc-6a583661-1efd-4b8a-9e0f-fabc8cb1a037  redis-data-gitea-redis-cluster-0       gitea        ubuntu     gitea-redis-cluster-0                    redis-data          296Gi  102Gi  194Gi      34.38  1073874  154608942  0.69   
 pvc-5fcb04e7-7650-4baa-8de4-d23b1d7d70f8  gitlab-minio                           gitlab       ubuntu     gitlab-minio-6bd5447587-96g5t            export              296Gi  102Gi  194Gi      34.39  1073874  154608942  0.69   
 pvc-9e1f2880-5aa9-4df8-9b61-1d97f29395bc  data-harbor-trivy-0                    harbor       ubuntu     harbor-trivy-0                           data                296Gi  102Gi  194Gi      34.38  1073875  154608941  0.69   
 pvc-b5b0558d-20d1-4595-93a4-139d00f2ad9f  data-gitea-postgresql-ha-postgresql-2  gitea        ubuntu     gitea-postgresql-ha-postgresql-2         data                296Gi  102Gi  194Gi      34.39  1073874  154608942  0.69   
 pvc-982cc54f-25ed-4ab8-a944-f6403ad85bc7  redis-data-gitea-redis-cluster-1       gitea        ubuntu     gitea-redis-cluster-1                    redis-data          296Gi  102Gi  194Gi      34.38  1073874  154608942  0.69   
 pvc-279d9a64-877b-4efd-93ac-2327c5045aa0  data-gitlab-postgresql-0               gitlab       ubuntu     gitlab-postgresql-0                      data                296Gi  102Gi  194Gi      34.38  1073874  154608942  0.69   
 pvc-7ceda06b-a3ad-4eef-a1ef-637e8342a4f2  uptime-kuma-pvc                        uptime-kuma  ubuntu     uptime-kuma-857d658999-c5zj7             uptime-kuma-volume  296Gi  102Gi  194Gi      34.38  1073874  154608942  0.69   
 pvc-dad89485-d93f-4200-8dee-0d6ff4edb4ee  data-harbor-redis-0                    harbor       ubuntu     harbor-redis-0                           data                296Gi  102Gi  194Gi      34.39  1073874  154608942  0.69   
 pvc-476589fd-ed2d-4bf6-b3ff-34bfe21580a6  harbor-registry                        harbor       ubuntu     harbor-registry-9dc5ff9cf-72nmx          registry-data       296Gi  102Gi  194Gi      34.38  1073874  154608942  0.69   
 pvc-0ae3c482-1780-4255-b6a6-fddba69fcc7f  redis-data-gitea-redis-cluster-3       gitea        ubuntu     gitea-redis-cluster-3                    redis-data          296Gi  102Gi  194Gi      34.38  1073874  154608942  0.69   
 pvc-a7c682b2-97b7-4858-8235-d8640f9a5476  data-gitea-postgresql-ha-postgresql-0  gitea        ubuntu     gitea-postgresql-ha-postgresql-0         data                296Gi  102Gi  194Gi      34.38  1073874  154608942  0.69   
 pvc-38573097-b450-4a47-87f1-10b13823c73b  database-data-harbor-database-0        harbor       ubuntu     harbor-database-0                        database-data       296Gi  102Gi  194Gi      34.38  1073875  154608941  0.69   
 pvc-afc565c0-818e-46fa-a7d5-acb180a73274  data-gitea-postgresql-ha-postgresql-1  gitea        ubuntu     gitea-postgresql-ha-postgresql-1         data                296Gi  102Gi  194Gi      34.39  1073874  154608942  0.69   
 pvc-370a60c9-712c-478b-8177-fb6880150da0  gitlab-prometheus-server               gitlab       ubuntu     gitlab-prometheus-server-c4478546-8vv4t  storage-volume      296Gi  102Gi  194Gi      34.38  1073874  154608942  0.69   
 pvc-994c1fba-d347-431d-96f2-e34efd5915b4  redis-data-gitea-redis-cluster-5       gitea        ubuntu     gitea-redis-cluster-5                    redis-data          296Gi  102Gi  194Gi      34.38  1073875  154608941  0.69   
 pvc-ced766da-f906-4aa5-94e0-a376b73bc1e3  minio                                  minio        ubuntu     minio-658557d479-plskm                   export              296Gi  102Gi  194Gi      34.38  1073874  154608942  0.69   
```

Get special namespace pv usage

```shell
$ kubectl dfpv -n minio

 PV NAME                                   PVC NAME  NAMESPACE  NODE NAME  POD NAME                VOLUME MOUNT NAME  SIZE   USED   AVAILABLE  %USED  IUSED    IFREE      %IUSED 
 pvc-ced766da-f906-4aa5-94e0-a376b73bc1e3  minio     minio      ubuntu     minio-658557d479-plskm  export             296Gi  102Gi  194Gi      34.38  1073874  154608942  0.69 
```

## Uninstalling the app

```shell
$ sealos run docker.io/labring/kubectl-df-pv:v0.3.0 -e uninstall=true
```
