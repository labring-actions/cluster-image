FROM scratch
COPY . .
CMD ["cp opt/* /usr/bin/","cilium install --chart-directory cilium --helm-set kubeProxyReplacement=strict,k8sServiceHost=apiserver.cluster.local,k8sServicePort=6443,image.override=quay.io/cilium/cilium:v1.12.0,operator.image.override=quay.io/cilium/operator-generic:v1.12.0"]
