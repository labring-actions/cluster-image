# Filebeat

Filebeat is an open source file harvester, mostly used to fetch logs files and feed them into logstash. Together with the libbeat lumberjack output is a replacement for [logstash-forwarder](https://github.com/elastic/logstash-forwarder).

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/filebeat:v8.5.1
```

Get app status

```shell
$ helm -n elastic-system ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n elastic-system uninstall filebeat
```

## Configuration

Refer to filebeat values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/filebeat:v8.5.1 \
-e NAME=my-filebeat -e NAMESPACE=my-filebeat -e HELM_OPTS="--set daemonset.hostNetworking=true"
```
