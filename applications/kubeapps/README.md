## overview

[Kubeapps](https://github.com/vmware-tanzu/kubeapps) is A web-based UI for deploying and managing applications in Kubernetes clusters.


To retrieve the token
```
kubectl get --namespace default secret kubeapps-operator-token -o go-template='{{.data.token | base64decode}}'
```
