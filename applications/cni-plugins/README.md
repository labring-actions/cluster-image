## CNI Plugins

Some CNI network plugins, maintained by the containernetworking team. For more information, see the [CNI website](https://www.cni.dev/).

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x

## Installing the app

To install the app with sealos run  command:

```bash
sealos run docker.io/labring/cni-plugin:v1.3.0
```

These commands deploy cni-plugin binary on the Kubernetes cluster in the `/opt/cni/bin` directory，list app using

```bash
$ ls /opt/cni/bin
```

## Uninstalling the app

```bash
rm -rf /opt/cin/bin/<cni-plugins>
```
