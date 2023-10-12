# Vector-operator

Kubernetes Operator for deploy and configure Vector.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/vector-operator:v0.0.30
```

Get app status

```shell
$ helm -n Vector-operator ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n vector-operator uninstall vector-operator
```

## Configuration

Refer to Vector-operator values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/vector-operator:v0.0.30 \
-e NAME=my-vector-operator -e NAMESPACE=my-vector-operator -e HELM_OPTS="--set vector.enable=true"
```

## Quick start

Install elasticsearch

```bash
sealos run docker.io/labring/bitnami-elasticsearch:v8.10.0
```

Install kibana

```bash
sealos run docker.io/labring/bitnami-kibana:v8.10.2
```

Create VectorPipeline CR for get all kubernetes logs.

```yaml
cat <<EOF | kubectl apply -f -
apiVersion: observability.kaasops.io/v1alpha1
kind: VectorPipeline
metadata:
  name: kubernetes-logs
  namespace: vector-operator
spec:
  sources:
    kubernetes_logs:
      type: "kubernetes_logs"
  sinks:
    es_cluster:
      type: "elasticsearch"
      inputs:
        - "kubernetes_logs"
      endpoints:
        - "http://elasticsearch.elastic-system:9200"
      bulk:
        index: "vector-%Y-%m-%d"
EOF
```
