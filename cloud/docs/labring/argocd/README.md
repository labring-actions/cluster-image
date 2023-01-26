# Argo CD

## Basic sealos cluster installation

Refer to [Cluster installation Kubernetes](https://www.sealos.io/docs/getting-started/kuberentes-life-cycle)

## How to install

Run a single command:

```shell
sealos run labring/argocd:v2.5.3
```

## How to use

- Get service Nodeport

```shell
kubectl -n argocd get svc
```

- Get  admin password

```shell
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

- Access with browser
