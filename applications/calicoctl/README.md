# Calicoctl

Calico CLI tool.

## Prerequisites

- Kubernetes (depends on the app requirements)
- sealos v4.x

## Installing the app

```
$ sealos run docker.io/labring/calicoctl:v3.26.1
```

These commands deploy calicoctl to all kubernetes nodes:

```bash
$ which calicoctl
```

## Uninstalling the app

To uninstall/delete the `calicoctl` app:

```bash
$ rm -rf /usr/local/bin/calicoctl
```
