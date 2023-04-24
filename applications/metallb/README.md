# metallb

MetalLB is a load-balancer implementation for bare metal kubernetes clusters, using standard routing protocols.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos v4.x
- helm v3.x

## Installing the app

To install the app with sealos run  command:

```bash
sealos run docker.io/labring/metallb:v0.13.9
```

These commands deploy metallb with helm to the Kubernetes cluster，list app using:

```bash
helm -n metallb-system ls
```

## Uninstalling the app

To uninstall/delete the `metallb` app:

```bash
sealos run docker.io/labring/metallb:v0.13.9 -e uninstall=true
```

The command removes all the resource associated with the installtion.

## Custome configuraton

Custome  metallb helm values with --set.

```bash
sealos run docker.io/labring/metallb:v0.13.9 \
  -e addresses="192.168.100.100-192.168.100.200"
```

