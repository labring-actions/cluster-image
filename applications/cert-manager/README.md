# Cert-manager

Automatically provision and manage TLS certificates in Kubernetes.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x
- Helm v3.x.x

## Install the app

```shell
sealos run docker.io/labring/cert-manager:v1.13.2
```

Get app status

```shell
$ helm -n cert-manager ls
```

## Uninstalling the app

Before continuing, ensure that all cert-manager resources that have been created by users have been deleted. You can check for any existing resources with the following command:

```bash
kubectl get Issuers,ClusterIssuers,Certificates,CertificateRequests,Orders,Challenges --all-namespaces
```

Once all these resources have been deleted you are ready to uninstall cert-manager using the procedure determined by how you installed.

```shell
helm -n cert-manager uninstall cert-manager
```

## Configuration

Refer to cert-manager `values.yaml` for the full run-down on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `seaos run -e HELM_OPTS=`. 

For example:

```shell
$ sealos run docker.io/labring/cert-manager:v1.13.2  -e HELM_OPTS="--set installCRDs=true"
```
