# Skopeo

skopeo is a command line utility that performs various operations on container images and image repositories.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x

## Installing the app

To install the app with sealos run  command:

```bash
sealos run docker.io/labring/skopeo:v1.13.0
```

These commands deploy skopeo binary on the Kubernetes cluster in the `/usr/bin` directory，list app using

```bash
$ which skopeo
```

## Uninstalling the app

To uninstall/delete the `podman` app:

```bash
sealos run docker.io/labring/skopeo:v1.13.0 -e uninstall=true
```

The command removes all the binary files associated with the installtion.
