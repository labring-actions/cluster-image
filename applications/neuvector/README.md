# neuvector

NeuVector Full Lifecycle Container Security Platform delivers the only cloud-native security with uncompromising end-to-end protection from DevOps vulnerability protection to automated run-time security, and featuring a true Layer 7 container firewall.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos v4.x
- helm v3.x

## Installing the app

To install the app with sealos run  command:

```bash
sealos run docker.io/labring/neuvector:v5.1.0
```

These commands deploy neuvector with helm to the Kubernetes cluster，list app using:

```bash
helm -n neuvector ls
```

## Uninstalling the app

To uninstall/delete the `neuvector` app:

```bash
sealos run docker.io/labring/neuvector:v5.1.0 -e uninstall=true
```

The command removes all the resource associated with the installtion.

## Custome configuraton

Custome  neuvector helm values with --set.

```bash
sealos run docker.io/labring/neuvector:v5.1.0 \
-e HELM_OPTS="--set controller.replicas=1 --set controller.pvc.enabled=true --set controller.pvc.accessModes[0]=ReadWriteOnce --set cve.scanner.replicas=1"
```

