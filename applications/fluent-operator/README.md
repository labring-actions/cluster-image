# Fluent-operator

[Operate Fluent Bit and Fluentd](https://github.com/fluent/fluent-operator) in the Kubernetes way - Previously known as FluentBit Operator.

This cluster image bootstraps a fluent-bit application using the [fluent-bit Helm chart](https://github.com/fluent/helm-charts).

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/fluent-operator:v2.5.0
```

Get app status

```shell
$ helm -n fluent ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n fluent uninstall fluent-operator
```

## Configuration

Refer to fluent-operator values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `sealos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/bitnami-fluent-bit：v2.1.10 \
-e NAME=my-fluent-operator -e NAMESPACE=my-fluent-operator -e HELM_OPTS="--set containerRuntime=containerd \
--set fluentbit.output.es.enable=true \
--set fluentbit.output.es.host=elasticsearch.elasticsearch \
--set fluentbit.output.es.suppressTypeName=On"
```

The configuration is as follows

```yaml
root@ubuntu:~# kubectl -n fluent get secrets fluent-bit-config -o jsonpath="{.data.fluent-bit\.conf}" | base64 -d
[Service]
    Http_Server    true
    Parsers_File    parsers.conf
[Input]
    Name    systemd
    Path    /var/log/journal
    DB    /fluent-bit/tail/systemd.db
    DB.Sync    Normal
    Tag    service.*
    Systemd_Filter    _SYSTEMD_UNIT=containerd.service
    Systemd_Filter    _SYSTEMD_UNIT=kubelet.service
    Strip_Underscores    off
    storage.type    memory
[Input]
    Name    tail
    Path    /var/log/containers/*.log
    Read_from_Head    false
    Refresh_Interval    10
    Skip_Long_Lines    true
    DB    /fluent-bit/tail/pos.db
    DB.Sync    Normal
    Mem_Buf_Limit    100MB
    Parser    cri
    Tag    kube.*
    storage.type    memory
[Filter]
    Name    lua
    Match    kube.*
    script    /fluent-bit/config/containerd.lua
    call    containerd
    time_as_table    true
[Filter]
    Name    kubernetes
    Match    kube.*
    Kube_URL    https://kubernetes.default.svc:443
    Kube_CA_File    /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    Kube_Token_File    /var/run/secrets/kubernetes.io/serviceaccount/token
    Labels    false
    Annotations    false
[Filter]
    Name    nest
    Match    kube.*
    Operation    lift
    Nested_under    kubernetes
    Add_prefix    kubernetes_
[Filter]
    Name    modify
    Match    kube.*
    Remove    stream
    Remove    kubernetes_pod_id
    Remove    kubernetes_host
    Remove    kubernetes_container_hash
[Filter]
    Name    nest
    Match    kube.*
    Operation    nest
    Wildcard    kubernetes_*
    Nest_under    kubernetes
    Remove_prefix    kubernetes_
[Filter]
    Name    lua
    Match    service.*
    script    /fluent-bit/config/systemd.lua
    call    add_time
    time_as_table    true
[Output]
    Name    es
    Match_Regex    (?:kube|service)\.(.*)
    Host    elasticsearch.elasticsearch
    Port    9200
    Buffer_Size    20MB
    Logstash_Format    true
    Logstash_Prefix    ks-logstash-log
    Time_Key    @timestamp
    Generate_ID    true
    Replace_Dots    false
    Suppress_Type_Name    On
```
