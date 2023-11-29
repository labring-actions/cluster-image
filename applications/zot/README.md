# Zot

[zot](https://github.com/project-zot/zot) - A production-ready vendor-neutral OCI-native container image registry (purely based on OCI Distribution Specification)

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x

- PV provisioner support in the underlying infrastructure

## Install the app

```shell
sealos run docker.io/labring/zot:v2.0.0-rc7
```

Get app status

```shell
$ helm -n zot ls
```

## Access UI

Get service NodePort

```bash
$ kubectl -n zot get svc
```

Access with URL

```bash
http://<node-ip>:<node-port>
```

## Usage

> Notes: docker client not support yet.

Skopeo example, copy dockerhub nginx image to zot registry.

```bash
skopeo copy --dest-tls-verify=false \
  docker://docker.io/library/nginx:latest \
  docker://192.168.72.40:31536/nginx:latest
```

Helm example, upload helm charts to zot registry.

> Notes: helm version should >=v3.13.0.

```bash
helm pull bitnami/nginx
helm push --plain-http nginx-15.4.3.tgz oci://192.168.72.40:30973/nginx

helm install --plain-http nginx oci://192.168.72.40:30973/nginx/nginx \
-n nginx --create-namespace
```

## Uninstalling the app

Uninstall with helm command

```shell
helm -n zot uninstall zot
```

## Configuration

Refer to `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/zot:v2.0.0-rc7 -e HELM_OPTS="--set persistence=true --set pvc.create=true"
```
