# longhorn

Longhorn is a lightweight, reliable and easy-to-use distributed block storage system for Kubernetes.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x

## Install

```shell
sealos run docker.io/labring/longhorn:v1.5.1
```

Custome config

```shell
sealos run docker.io/labring/longhorn:v1.5.1 -e HELM_OPTS="--set service.ui.type=NodePort
```

Get pods status

```shell
root@node1:~# kubectl -n longhorn get pods
NAME                                                READY   STATUS    RESTARTS      AGE
csi-attacher-f98ff75fb-827fj                        1/1     Running   0             11m
csi-attacher-f98ff75fb-jmmfl                        1/1     Running   0             11m
csi-attacher-f98ff75fb-mfszv                        1/1     Running   0             11m
csi-provisioner-65cb5cc4ff-s5dxq                    1/1     Running   0             11m
csi-provisioner-65cb5cc4ff-t6x78                    1/1     Running   0             11m
csi-provisioner-65cb5cc4ff-vghdf                    1/1     Running   0             11m
csi-resizer-77cddbfc7c-jqht6                        1/1     Running   0             11m
csi-resizer-77cddbfc7c-z6qbn                        1/1     Running   0             11m
csi-resizer-77cddbfc7c-zvzfv                        1/1     Running   0             11m
csi-snapshotter-78cb65cc4f-j9lzg                    1/1     Running   0             11m
csi-snapshotter-78cb65cc4f-mdg2k                    1/1     Running   0             11m
csi-snapshotter-78cb65cc4f-tr7hr                    1/1     Running   0             11m
engine-image-ei-74783864-jhsff                      1/1     Running   0             11m
engine-image-ei-74783864-lj5xp                      1/1     Running   0             11m
engine-image-ei-74783864-lp7t7                      1/1     Running   0             11m
instance-manager-7301427efa1f97f1e4e5b290e40505a7   1/1     Running   0             11m
instance-manager-c06404b5e7a48f9af94f10c4793e2f3d   1/1     Running   0             11m
instance-manager-e6dc0507996a06650ce72eb20a6b2478   1/1     Running   0             8m12s
longhorn-csi-plugin-gxbft                           3/3     Running   0             11m
longhorn-csi-plugin-mntf7                           3/3     Running   2 (10m ago)   11m
longhorn-csi-plugin-svg5c                           3/3     Running   0             11m
longhorn-driver-deployer-5b49bfbf97-g9c4z           1/1     Running   0             12m
longhorn-manager-84rpr                              1/1     Running   2 (11m ago)   12m
longhorn-manager-dz42d                              1/1     Running   1 (11m ago)   12m
longhorn-manager-zj648                              1/1     Running   3 (11m ago)   12m
longhorn-ui-696697d5fc-5w7q4                        1/1     Running   0             12m
longhorn-ui-696697d5fc-drvm6                        1/1     Running   0             12m
```

Get storageclass

```shell
root@node1:~# kubectl get sc
NAME                 PROVISIONER              RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
longhorn (default)   driver.longhorn.io       Delete          Immediate              true                   14m
```

Access UI

```shell
http://192.168.1.10:32601
```

## uninstall

```shell
kubectl -n longhorn-system patch -p '{"value": "true"}' --type=merge lhs deleting-confirmation-flag
helm uninstall longhorn -n longhorn-system
```
