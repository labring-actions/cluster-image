# helmfile

Helmfile is a declarative spec for deploying helm charts. It lets you...

- Keep a directory of chart value files and maintain changes in version control.
- Apply CI/CD to configuration changes.
- Periodically sync to avoid skew in environments.

To avoid upgrades for each iteration of `helm`, the `helmfile` executable delegates to `helm` - as a result, `helm` must be installed.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- helm

## Installing the app

To install the app with sealos run  command:

```bash
sealos run docker.io/labring/helmfile:v0.155.0
```

These commands deploy helmfile and helmdiff plugin binary on the Kubernetes cluster in the `/usr/bin` directory，list app using

```bash
$ which helmfile
```

## Uninstalling the app

To uninstall/delete the `helmfile` app:

```bash
rm -f /usr/bin/helmfile
rm -rf /root/.local/share/helm/plugins/helm-diff
```

The command removes all the binary files associated with the installtion.

## Getting Started

Let's start with a simple `helmfile` and gradually improve it to fit your use-case!

Suppose the `helmfile.yaml` representing the desired state of your helm releases looks like:

```yaml
cat >helmfile.yaml<<EOF
repositories:
- name: bitnami
  url: https://charts.bitnami.com/bitnami

releases:
- name: nginx
  namespace: nginx
  chart: bitnami/nginx
  set:
  - name: service.type
    value: NodePort
EOF
```

Sync your Kubernetes cluster state to the desired one by running:

```bash
helmfile apply
```

Get app status

```bash
root@ubuntu:~# helm -n nginx ls
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
nginx   nginx           1               2023-03-23 12:38:31.151056659 +0800 CST deployed        nginx-13.2.30   1.23.3     

root@ubuntu:~# kubectl -n nginx get pods
NAME                     READY   STATUS    RESTARTS   AGE
nginx-5f678b794c-b6qd4   1/1     Running   0          77s

root@ubuntu:~# kubectl -n nginx get svc
NAME    TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
nginx   NodePort   10.96.3.164   <none>        80:31769/TCP   79s
```

uninstall helm app

```bash
helmfile destroy
```
