# kubevirt

**KubeVirt** is a virtual machine management add-on for Kubernetes. The aim is to provide a common ground for virtualization solutions on top of Kubernetes.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos v4.x

## Installing the app

To install the app with sealos run command:

```bash
sealos run docker.io/labring/kubevirt:v0.58.0
```

These commands deploy kubevirt with kubectl command to the Kubernetes cluster，list app using:

```bash
kubevctl -n kubevirt get pods
kubevctl -n cdi get pods
```

## Uninstalling the app

To uninstall/delete the `kubevirt` app:

```bash
sealos run docker.io/labring/kubevirt:v0.58.0 -e uninstall=true
```

The command removes all the resource associated with the installtion.
