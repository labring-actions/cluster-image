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
sealos run docker.io/labring/loki:v2.8.4
```

These commands deploy loki with helm to the Kubernetes cluster，list app using:

```bash
$ kubectl -n loki get pods 
NAME                                          READY   STATUS    RESTARTS   AGE
loki-backend-0                                1/1     Running   0          36m
loki-canary-pdlpn                             1/1     Running   0          36m
loki-gateway-5f5c6fdc9f-7qnmb                 1/1     Running   0          36m
loki-grafana-agent-operator-d7c684bf9-zsnsk   1/1     Running   0          36m
loki-logs-2rwg2                               2/2     Running   0          36m
loki-minio-0                                  1/1     Running   0          36m
loki-read-79d56b879d-qc57d                    1/1     Running   0          36m
loki-write-0                                  1/1     Running   0          36m
```

## Uninstalling the app

To uninstall/delete the `loki` app:

```bash
helm -n loki uninstall loki
```

The command removes all the resource associated with the installtion.

## Custome configuraton

Custome  neuvector helm values with --set.

```bash
sealos run docker.io/labring/loki:v2.8.4 \
-e HELM_OPTS="--set write.replicas=1 --set read.replicas=1 --set backend.replicas=1"
```
