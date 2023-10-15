# Bitnami Fluent-bit

Fluent Bit is a Fast and Lightweight Log Processor and Forwarder. It has been made with a strong focus on performance to allow the collection of events from different sources without complexity.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/bitnami-fluent-bit：v2.1.10
```

Get app status

```shell
$ helm -n fluent-bit ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n fluent-bit uninstall fluent-bit
```

## Configuration

Refer to bitnami-fluent-bit values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `sealos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/bitnami-fluent-bit：v2.1.10 \
-e NAME=my-bitnami-fluent-bit -e NAMESPACE=my-bitnami-fluent-bit -e HELM_OPTS="--set daemonset.enabled=true"
```

After the installation is completed, modify the configmap configuration. The example configuration is as follows

```yaml
$ kubectl -n fluent-bit get cm fluent-bit-config -o yaml
kind: ConfigMap
apiVersion: v1
data:
  custom_parsers.conf: |
    [PARSER]
        Name docker_no_time
        Format json
        Time_Keep Off
        Time_Key time
        Time_Format %Y-%m-%dT%H:%M:%S.%L
  fluent-bit.conf: |
    [SERVICE]
        Daemon Off
        Flush 1
        Log_Level info
        Parsers_File /opt/bitnami/fluent-bit/conf/parsers.conf
        Parsers_File /opt/bitnami/fluent-bit/conf/custom_parsers.conf
        HTTP_Server On
        HTTP_Listen 0.0.0.0
        HTTP_Port 2020
        Health_Check On

    [INPUT]
        Name tail
        Path /var/log/containers/*.log
        multiline.parser docker, cri
        Tag kube.*
        Mem_Buf_Limit 5MB
        Skip_Long_Lines On

    [INPUT]
        Name systemd
        Tag host.*
        Systemd_Filter _SYSTEMD_UNIT=kubelet.service
        Read_From_Tail On

    [FILTER]
        Name kubernetes
        Match kube.*
        Merge_Log On
        Keep_Log Off
        K8S-Logging.Parser On
        K8S-Logging.Exclude On

    [OUTPUT]
        Name es
        Match kube.*
        Host elasticsearch.elasticsearch
        Logstash_Format On
        Retry_Limit False
        Suppress_Type_Name On

    [OUTPUT]
        Name es
        Match host.*
        Host elasticsearch.elasticsearch
        Logstash_Format On
        Logstash_Prefix node
        Retry_Limit False
        Suppress_Type_Name On
......
```
