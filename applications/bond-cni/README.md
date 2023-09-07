# bond-cni

Bond-cni is for fail-over and high availability of networking in cloudnative orchestration.

## Prerequisites

- Kubernetes (depends on the app requirements)
- sealos v4.x.x
- multus-cni

## Installing the app

To install the app with sealos run  command:

```bash
$ sealos run docker.io/labring/bond-cni:latest
```

These commands deploy bond-cni  binary to all Kubernetes cluster nodes，list binary location using:

```bash
$ ls /opt/cni/bin/ | grep bond
bond
```

## Uninstalling the app

To uninstall/delete the app:

```bash
rm -rf /opt/cni/bin/bond
```
