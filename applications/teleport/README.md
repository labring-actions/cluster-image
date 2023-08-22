# Teleport

The easiest, most secure way to access infrastructure.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- Helm 3.x.x
- PV provisioner support in the underlying infrastructure
-  load-balancer eg: metallb

## Installing the app

```shell
$ sealos run docker.io/labring/teleport:v13.3.4
```

Get pods status

```shell
$ kubectl  -n teleport-cluster get pods
NAME                                      READY   STATUS    RESTARTS   AGE
teleport-cluster-auth-000000000-00000     1/1     Running   0          114s
teleport-cluster-proxy-0000000000-00000   1/1     Running   0          114s
```

Get service status

```shell
$ kubectl -n teleport-cluster get svc
NAME                        TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)             AGE
teleport-cluster            LoadBalancer   10.96.1.28    192.168.72.203   443:32587/TCP       65m
teleport-cluster-auth       ClusterIP      10.96.2.201   <none>           3025/TCP,3026/TCP   65m
teleport-cluster-auth-v12   ClusterIP      None          <none>           <none>              65m
teleport-cluster-auth-v13   ClusterIP      None          <none>           <none>  
```

## Access the app

```
https://teleport.example.com
```

## Uninstalling the app

```shell
$ helm -n teleport-cluster uninstall teleport-cluster
```

## Configuration

Refer to  teleport`values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/teleport:v13.3.4 \
-e NAME=myteleport -e NAMESPACE=myteleport -e HELM_OPTS="--set service.type=NodePort"
```
