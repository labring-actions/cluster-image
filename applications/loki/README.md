# Loki

Loki is a log aggregation system designed to store and query logs from all your applications and infrastructure.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos v4.x
- helm v3.x
- Persistent storage provide dynamic pv

## Installing the app

To install the app with sealos run  command:

```bash
sealos run docker.io/labring/loki:v2.6.1
```

These commands deploy loki with helm to the Kubernetes cluster，list app using:

```bash
helm -n loki-stack ls
```

## Custome configuraton

Custome  neuvector helm values with --set.

```bash
sealos run docker.io/labring/loki:v2.6.1 -e HELM_OPTS="--set loki.persistence.enabled=true"
```

## Uninstalling the app

To uninstall/delete the `loki` app:

```bash
sealos run docker.io/labring/loki:v2.6.1 -e uninstall=true
```

The command removes all the resource associated with the installtion.
