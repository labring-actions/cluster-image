# Podman

Podman: A tool for managing OCI containers and pods.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x

## Installing the app

To install the app with sealos run  command:

```bash
sealos run docker.io/labring/podman:v4.5.1
```

These commands deploy podman binary on the Kubernetes cluster in the `/usr/local/bin` directory，list app using

```bash
$ which podman
```

## Uninstalling the app

To uninstall/delete the `podman` app:

```bash
sealos run docker.io/labring/podman:v4.5.1 -e uninstall=true
```

The command removes all the binary files associated with the installtion.
