# Rainbond

No need to know Kubernetes' cloud native application management platform.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- Helm 3.x.x
- RWX PV provisioner support in the underlying infrastructure
- RWO PV provisioner support in the underlying infrastructure

## Installing the app

Sample Installation Command:

```shell
$ sealos run docker.io/labring/rainbond:v5.15.0 -e HELM_OPTS=" \
--set operator.env[0].name=CONTAINER_RUNTIME \
--set operator.env[0].value=containerd \
--set Cluster.RWX.enable=true \
--set Cluster.RWX.config.storageClassName=openebs-kernel-nfs \
--set Cluster.RWO.enable=true \
--set Cluster.RWO.storageClassName=openebs-hostpath"
```

Get pods status

```shell
$ kubectl -n rbd-system get pods
NAME                                        READY   STATUS    RESTARTS   AGE
dashboard-metrics-scraper-6948f9475-lmgd4   1/1     Running   0          12m
kubernetes-dashboard-cd594bb64-mn29s        1/1     Running   0          12m
metrics-server-56df97f57-snb7t              1/1     Running   0          12m
rainbond-operator-85bb988bb8-wxwmm          1/1     Running   0          12m
rbd-api-7d7b876b74-xg4vt                    1/1     Running   0          12m
rbd-app-ui-765669864b-jwrf4                 1/1     Running   0          11m
rbd-chaos-nbn4d                             1/1     Running   0          12m
rbd-chaos-qgxfs                             1/1     Running   0          12m
rbd-db-0                                    2/2     Running   0          12m
rbd-etcd-0                                  1/1     Running   0          12m
rbd-eventlog-0                              1/1     Running   0          12m
rbd-gateway-8tqkr                           1/1     Running   0          12m
rbd-gateway-bpzkp                           1/1     Running   0          12m
rbd-hub-868ccb6645-nfbqs                    1/1     Running   0          12m
rbd-monitor-0                               1/1     Running   0          12m
rbd-mq-5c766bf9cf-2rqp6                     1/1     Running   0          12m
rbd-node-d7cjv                              1/1     Running   0          12m
rbd-node-j57vw                              1/1     Running   0          12m
rbd-node-kjfcf                              1/1     Running   0          12m
rbd-resource-proxy-947f9fc96-jhkjg          1/1     Running   0          12m
rbd-webcli-6b785c49b5-74fl2                 1/1     Running   0          12m
rbd-worker-7d7786c46f-mxp9t                 1/1     Running   0          12m

```

Get pvc status

```shell
$ kubectl -n rbd-system get pvc
NAME                  STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS         AGE
data                  Bound    pvc-be13276d-4948-466e-9df6-6f56c3062c52   20Gi       RWO            openebs-hostpath     27m
data-rbd-monitor-0    Bound    pvc-1a35e6b9-45a6-4c21-9e4a-ff6e5a97731e   20Gi       RWO            openebs-hostpath     27m
rbd-api               Bound    pvc-4436a9ae-f85e-4b37-ac73-1123514dd3d1   1Gi        RWX            openebs-kernel-nfs   26m
rbd-app-ui            Bound    pvc-6d1591d0-c3dc-42a0-91dd-b34c155a419e   10Gi       RWX            openebs-kernel-nfs   25m
rbd-chaos-cache       Bound    pvc-cd7d1dcc-fea9-4b7b-bf6b-afcc53905788   10Gi       RWX            openebs-kernel-nfs   26m
rbd-cpt-grdata        Bound    pvc-f59fa5d4-32bb-4b80-98b1-0704d2bf255f   20Gi       RWX            openebs-kernel-nfs   28m
rbd-db-rbd-db-0       Bound    rbd-db                                     1Gi        RWO            manual               27m
rbd-etcd-rbd-etcd-0   Bound    rbd-etcd                                   1Gi        RWO            manual               28m
rbd-hub               Bound    pvc-5571e2cb-ad56-4f40-9235-7e408c73e1a7   10Gi       RWX            openebs-kernel-nfs   28m
```

## Access the app

Access rainbond UI
```shell
http://192.168.1.10:7070
```

## Uninstalling the app

```shell
helm -n rbd-system uninstall rainbond
```

## Configuration

Refer to rainbond `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/rainbond:v5.15.0 \
-e NAME=myrainbond -e NAMESPACE=myrainbond -e HELM_OPTS=" \
--set operator.env[0].name=CONTAINER_RUNTIME \
--set operator.env[0].value=containerd \
--set Cluster.RWX.enable=true \
--set Cluster.RWX.config.storageClassName=openebs-kernel-nfs \
--set Cluster.RWO.enable=true \
--set Cluster.RWO.storageClassName=openebs-hostpath"
```
