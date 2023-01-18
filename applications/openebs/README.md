## Overview

This openebs application only enabled [localpv-hostpath](https://openebs.io/docs/user-guides/localpv-hostpath).

## Install

Install with sealos run

```shell
sealos run labring/openebs:v3.3.0
```

Get pods status

```shell
root@ubuntu:~# root@ubuntu:~# kubectl -n openebs get pods 
NAME                                          READY   STATUS    RESTARTS   AGE
openebs-localpv-provisioner-7b4db8497-68xpr   1/1     Running   0          9m18s
```

Get StorageClass status

```shell
root@ubuntu:~# kubectl get sc
NAME                         PROVISIONER        RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
openebs-hostpath (default)   openebs.io/local   Delete          WaitForFirstConsumer   false                  9m22s
```
Now it is ready to provide dynamic PV.

## Uninstall

Uninstall with helm comand.

```shell
helm -n openebs uninstall openebs
```
