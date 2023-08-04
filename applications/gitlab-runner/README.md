

# GitLab-runner

The official way of deploying a GitLab Runner instance into your Kubernetes cluster is by using the `gitlab-runner` Helm chart.

This chart configures GitLab Runner to:

- Run using the [Kubernetes executor](https://docs.gitlab.com/runner/executors/kubernetes.html) for GitLab Runner.
- For each new job it receives from GitLab CI/CD, provision a new pod within the specified namespace to run it.

## Prerequisites

- Kubernetes(depends on the app requirements)
- sealos 4.x.x
- gitlab

Get  self-signed certificate

```
kubectl -n gitlab get secret gitlab-gitlab-tls --template='{{ index .data "tls.crt" }}' | base64 -d > gitlab.crt
kubectl -n gitlab-runner create secret generic gitlab-runner-certs \
--from-file=gitlab.example.com.crt=gitlab.crt \
--from-file=registry.example.com.crt=gitlab.crt \
--from-file=minio.example.com.crt=gitlab.crt
```

## Install

```shell
sealos run docker.io/labring/gitlab-runner:v16.2.0 \
-e HELM_OPTS="--set gitlabUrl=https://gitlab.example.com \
--set runnerToken=glrt--T8oByDyAV6vsWFWsteF \
--set certsSecretName=gitlab-runner-certs \
--set rbac.create=true \
--set rbac.clusterWideAccess=true
"
```

Get pods status

```shell
root@ubuntu:~# kubectl -n gitlab-runner get pods
NAME                             READY   STATUS    RESTARTS   AGE
gitlab-runner-5db97476f9-2mnsz   1/1     Running   0          3m29s
```

## uninstall

```shell
helm -n gitlab-runner uninstall gitlab-runner
```
