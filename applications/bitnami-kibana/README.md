# Bitnami Kibana

Kibana is an open source, browser based analytics and search dashboard for Elasticsearch. Kibana strives to be easy to get started with, while also being flexible and powerful.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos 4.x.x
- Helm 3.x.x

## Installing the app

Run app with sealos

```shell
$ sealos run docker.io/labring/bitnami-kibana:v8.10.2
```

Get app status

```shell
$ helm -n kibana ls
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n kibana uninstall kibana
```

## Configuration

Refer to bitnami-kibana values.yaml for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `sealos run -e HELM_OPTS=`. For example,

```shell
$ sealos run docker.io/labring/bitnami-kibana:v8.10.2 \
-e NAME=my-kibana -e NAMESPACE=my-kibana -e HELM_OPTS="--set service.type=NodePort \
--set elasticsearch.hosts[0]=elasticsearch.elasticsearch \
--set elasticsearch.port=9200"
```
