\# kube-prometheus-stack

Installs the [kube-prometheus stack](https://github.com/prometheus-operator/kube-prometheus), a collection of Kubernetes manifests, [Grafana](http://grafana.com/) dashboards, and [Prometheus rules](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/) combined with documentation and scripts to provide easy to operate end-to-end Kubernetes cluster monitoring with [Prometheus](https://prometheus.io/) using the [Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator).

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos v4.x
- helm v3.x

## Installing the app

To install the app with sealos run  command:

```bash
sealos run docker.io/labring/kube-prometheus-stack:v0.63.0
```

These commands deploy kube-prometheus-stack with helm to the Kubernetes cluster，list app using:

```bash
helm -n monitoring ls
```

## Uninstalling the app

Uninstall with helm command:

```
helm -n monitoring uninstall prometheus
```

Uninstall with sealos command:

```bash
sealos run docker.io/labring/kube-prometheus-stack:v0.63.0 -e uninstall=true
```

The command removes all the resource associated with the installtion.

## Build cluster image

Get prometheus-operator [release tag](https://github.com/prometheus-operator/prometheus-operator/releases), and create new github issues and comments, or create comments within [existing issues](https://github.com/labring-actions/cluster-image/issues/36).

The sample comment content is as follows：

```
/imagebuild_apps kube-prometheus-stack v0.63.0
```
