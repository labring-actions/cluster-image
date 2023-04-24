# sriov-network-operator

The Sriov Network Operator is designed to help the user to provision and configure SR-IOV CNI plugin and Device plugin in the Openshift cluster.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos v4.x
- helm v3.x

## Installing the app

To install the app with sealos run  command:

```bash
sealos run docker.io/labring/sriov-network-operator:v1.2.0
```

These commands deploy sriov-network-operator with helm to the Kubernetes cluster，list app using:

```bash
helm -n sriov-network-operator ls
```

## Uninstalling the app

To uninstall/delete the `sriov-network-operator` app:

```bash
sealos run docker.io/labring/sriov-network-operator:v1.2.0 -e uninstall=true
```

The command removes all the resource associated with the installtion.
