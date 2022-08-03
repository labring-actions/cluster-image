FROM scratch
COPY . .
CMD ["cp opt/cilium /usr/bin/","cp opt/hubble /usr/bin/","cilium install --chart-directory charts/cilium --helm-set kubeProxyReplacement=strict,k8sServiceHost=apiserver.cluster.local,k8sServicePort=6443"]
