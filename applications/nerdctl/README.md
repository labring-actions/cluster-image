## nerdctl

contaiNERD CTL - Docker-compatible CLI for containerd, with support for Compose, Rootless, eStargz, OCIcrypt, IPFS, ...

## Install

Install nerdctl with buildkit to `/usr/local/bin`, the image does not contain containerd, use the default containerd of the sealos cluster.

```shell
sealos run docker.io/labring/nerdctl:v1.2.1
```

pull image

```shell
nerdctl pull docker.io/library/nginx:1.23.3
```

build image

```shell
nerdctl build -t docker.io/labring/test:v1.1.0 .
```

## Uinstall

```shell
sealos run docker.io/labring/nerdctl:v1.2.1 -e uninstall=true
```
