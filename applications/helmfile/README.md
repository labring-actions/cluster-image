# helmfile

Helmfile is a declarative spec for deploying helm charts. It lets you...

- Keep a directory of chart value files and maintain changes in version control.
- Apply CI/CD to configuration changes.
- Periodically sync to avoid skew in environments.

To avoid upgrades for each iteration of `helm`, the `helmfile` executable delegates to `helm` - as a result, `helm` must be installed.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x

## Installing the app

To install the app with sealos run  command:

```bash
sealos run docker.io/labring/helmfile:v0.151.0
```

These commands deploy helm、helmfile and helmdiff plugin binary on the Kubernetes cluster in the `/usr/bin` directory，list app using

```bash
$ which helm
$ which helmfile
```

## Uninstalling the app

To uninstall/delete the `helmfile` app:

```bash
sealos run docker.io/labring/helmfile:v0.151.0 -e uninstall=true
```

The command removes all the binary files associated with the installtion.
