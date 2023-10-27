# kubernetes-dashboard

[Kubernetes Dashboard](https://github.com/kubernetes/dashboard) is a general purpose, web-based UI for Kubernetes clusters. It allows users to manage applications running in the cluster and troubleshoot them, as well as manage the cluster itself.

This cloud image build with [kubernetes-dashboard helm charts](https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard) in the [artifacthub.io](https://artifacthub.io/).

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- Helm 3.x.x
- metrics-server

## Installing the app

To install the app with sealos run  command:

```bash
sealos run docker.io/labring/kubernetes-dashboard:v2.7.0
```

These commands deploy kubernetes-dashboard helm chart on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list -A`

## Custome configuraton

Custome  neuvector helm values with --set.

```bash
sealos run docker.io/labring/kubernetes-dashboard:v2.7.0 -e HELM_OPTS="--set service.type=LoadBalancer"
```

## Access

Get admin user token

```
kubectl -n kubernetes-dashboard get secrets admin-user -o go-template='{{.data.token | base64decode}}'
```

Get access nodeport

```
kubectl -n kubernetes-dashboard get svc
```

Access url

```
https://<node-ip>:<node-port>
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
helm -n kubernetes-dashboard uninstall kubernetes-dashboard
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
