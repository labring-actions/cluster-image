# Istio-bookinfo

This example deploys a sample application composed of four separate microservices used to demonstrate various Istio features.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Istio
- PV provisioner support in the underlying infrastructure

## Install the app

```shell
sealos run docker.io/labring/istio-bookinfo:v1.20.1
```

Get app status

```shell
$ kubectl get pods
NAME                             READY   STATUS    RESTARTS   AGE
details-v1-5f4d584748-8fqjg      2/2     Running   0          13m
loki-0                           2/2     Running   0          13m
productpage-v1-564d4686f-d9g7b   2/2     Running   0          13m
ratings-v1-686ccfb5d8-qz92m      2/2     Running   0          13m
reviews-v1-86896b7648-2rhbj      2/2     Running   0          13m
reviews-v2-b7dcd98fb-9q5dh       2/2     Running   0          13m
reviews-v3-5c5cc7b6d-6gcl5       2/2     Running   0          13m
```

## Uninstalling the app

To completely uninstall Istio-bookinfo from a cluster, run the following command:

```bash
container_name=$(sealos ps -f ancestor=istio-bookinfo --notruncate --format "{{.ContainerName}}")
cd /var/lib/sealos/data/default/applications/${container_name}/workdir
kubectl delete -f manifests/addons/
kubectl delete -f manifests/bookinfo.yaml
kubectl delete -f manifests/bookinfo-gateway.yaml
```
