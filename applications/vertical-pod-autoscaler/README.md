# Vertical-Pod-Autoscaler

Vertical Pod Autoscaler (VPA) frees users from the necessity of setting up-to-date resource limits and requests for the containers in their pods.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- metrics-server

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/vertical-pod-autoscaler:v0.14.0
```

Get app status

```shell
$ kubectl -n kube-system get pods
```

## Uninstalling the app

Get mount path which is `default-xxxxxx`.

```shell
$ sealos ps -f ancestor=vertical-pod-autoscaler --notruncate
```

change to that path and uninstall vertical-pod-autoscaler

```shell
$ cd /var/lib/sealos/data/default/applications/default-2tp9ynh0/workdir/autoscaler/vertical-pod-autoscaler
$ ./hack/vpa-down.sh
```
