FROM scratch
COPY . .
CMD ["cp opt/* /usr/bin/","helm install cilium charts/cilium --namespace=kube-system --set kubeProxyReplacement=strict --set k8sServiceHost=apiserver.cluster.local --set k8sServicePort=6443"]
