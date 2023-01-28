## Overview

[Redis Operator](https://github.com/spotahome/redis-operator) creates/configures/manages high availability redis with sentinel automatic failover atop Kubernetes.

## Install redis-operator

Default running

```shell
sealos run labring/redis-operator:v1.2.4
```

Get the operator pods status

```shell
$ kubectl -n redis-operator get pods 
NAME                             READY   STATUS    RESTARTS      AGE
redis-operator-8fccdbc45-r8z4h   1/1     Running   1 (20m ago)   21m
```

Get the cluster pods status

```shell
$ kubectl -n redis-example get pods 
NAME                                 READY   STATUS    RESTARTS   AGE
rfr-redisfailover-0                  1/1     Running   0          21m
rfr-redisfailover-1                  1/1     Running   0          21m
rfr-redisfailover-2                  1/1     Running   0          21m
rfs-redisfailover-7c9fd994c5-gr8v7   1/1     Running   0          21m
rfs-redisfailover-7c9fd994c5-pzs92   1/1     Running   0          21m
rfs-redisfailover-7c9fd994c5-r2p7j   1/1     Running   0          21m
```

## Custome redis-operator helm values

Create a sealos config file, the content of the `data` section will merge into redis-operator helm values file.

```yaml
cat <<EOF>redis-operator-config.yaml
apiVersion: apps.sealos.io/v1beta1
kind: Config
metadata:
  name: redis-operator-config
spec:
  path: charts/redis-operator/values.yaml
  match: labring/redis-operator:v1.2.4
  strategy: merge
  data: |
    replicas: 2
    resources:
      requests:
        cpu: 100m
        memory: 128Mi
      limits:
        cpu: 100m
        memory: 128Mi
EOF
```

Notes: The value of the `path` field is bound to the installation command and is fixed. Do not modify it.

Install redis-operator with custome config.

```shell
sealos run labring/redis-operator:v1.2.4 --config-file redis-operator-config.yaml
```

Check the operator pods status.

```shell
$ kubectl -n redis-operator get pods 
NAME                             READY   STATUS    RESTARTS      AGE
redis-operator-8fccdbc45-cbq2z   1/1     Running   0             4m15s
redis-operator-8fccdbc45-r8z4h   1/1     Running   1 (39m ago)   40m
```

All support values:

https://github.com/spotahome/redis-operator/blob/master/charts/redisoperator/values.yaml

## Custome redisfailover cluster yaml file

Create a sealos config file, the content of the `data` section will override redis-operator basic.yaml file.

```yaml
cat <<EOF>redisfailover-config.yaml
apiVersion: apps.sealos.io/v1beta1
kind: Config
metadata:
  name: redisfailover-config
spec:
  path: manifests/basic.yaml
  match: labring/redis-operator:v1.2.4
  strategy: override
  data: |
      apiVersion: v1
      kind: Namespace
      metadata:
        name: redis-example
      apiVersion: databases.spotahome.com/v1
      kind: RedisFailover
      metadata:
        name: redisfailover
        namespace: redis-example
      spec:
        sentinel:
          replicas: 1
          resources:
            requests:
              cpu: 100m
            limits:
              memory: 100Mi
        redis:
          replicas: 1
          resources:
            requests:
              cpu: 100m
              memory: 100Mi
            limits:
              cpu: 400m
              memory: 500Mi
EOF
```

Notes: The value of the `path` field is bound to the installation command and is fixed. Do not modify it.

Install redis-operator with custome config.

```shell
sealos run labring/redis-operator:v1.2.4 --config-file redisfailover-config.yaml
```

The replicas changed to 1.

```shell
$ kubectl -n redis-example  get pods 
NAME                                 READY   STATUS    RESTARTS   AGE
rfr-redisfailover-0                  1/1     Running   0          55m
rfs-redisfailover-7c9fd994c5-r2p7j   1/1     Running   0          55m
```

All support config:

https://github.com/spotahome/redis-operator/tree/master/example/redisfailover

## Uninstall redis-operator and redis-cluster

Uninstall redis cluster

```shell
kubectl -n redis-example delete RedisFailover redisfailover
```

Uinstall redis operator

```shell
helm -n redis-operator uninstall redis-operator
```

