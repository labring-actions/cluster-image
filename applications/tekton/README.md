# Tekton

Cloud Native CI/CD, Learn more at https://tekton.dev/.

This image consists of the following components(install with kubectl apply release.yaml):

- **Tekton Pipelines** is the foundation of Tekton. It defines a set of Kubernetes Custom Resources that act as building blocks from which you can assemble CI/CD pipelines.
- **Tekton Triggers** allows you to instantiate pipelines based on events. For example, you can trigger the instantiation and execution of a pipeline every time a PR is merged against a GitHub repository. You can also build a user interface that launches specific Tekton triggers.
- **Tekton CLI** provides a command-line interface called tkn, built on top of the Kubernetes CLI, that allows you to interact with Tekton.
- **Tekton Dashboard** is a Web-based graphical interface for Tekton Pipelines that displays information about the execution of your pipelines. It is currently a work-in-progress.
- **Tekton Chain** provides tools to generate, store, and sign provenance for artifacts built with Tekton Pipelines.

## Prerequisites

- Kubernetes(depends on the app requirements)
- Sealos v4.x.x

## Install the app

```shell
$ sealos run docker.io/labring/tekton:v0.54.0
```

Get app status

```shell
$ kubectl get pods -A | grep tekton
```

## Access UI

Get service nodeport

```bash
$ kubectl -n tekton-pipelines get svc
NAME                                TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)                              AGE
tekton-dashboard                    NodePort    10.96.0.105   <none>        9097:31328/TCP                       3m46s
......
```

Access with the following url

```bash
http://<node-ip>:<node-port>
```

## Example

Notes: This cluster image already contains the docker images needed for the [git-clone task](https://hub.tekton.dev/tekton/task/git-clone) and the [kaniko task](https://hub.tekton.dev/tekton/task/kaniko).

```bash
gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:latest
gcr.io/kaniko-project/executor:latest
```

Git clone example

```yaml
$ cat git-clone-taskrun.yaml
apiVersion: tekton.dev/v1beta1
kind: TaskRun
metadata:
  generateName: git-clone-taskrun-
spec:
  taskRef:
    name: git-clone
  podTemplate:
    hostNetwork: true
  workspaces:
    - name: output
      emptyDir: {}
  params:
  - name: url
    value: https://github.com/tektoncd/pipeline.git
  - name: revision
    value: main
  - name: subdirectory
    value: pipeline
  - name: deleteExisting
    value: "true"
  - name: gitInitImage
    value: gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:latest
```

Apply the yaml file

```bash
kubectl apply -f git-clone-taskrun.yaml
```

## Uninstalling the app

Uninstall tekton

```shell
container_name=$(sealos ps -f ancestor=tekton --notruncate --format "{{.ContainerName}}")
cd /var/lib/sealos/data/default/applications/${container_name}/workdir
kubectl delete -f manifests/dashboard/
kubectl delete -f manifests/chains/
kubectl delete -f manifests/triggers/
kubectl delete -f manifests/pipeline/
```
