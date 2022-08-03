FROM scratch
COPY . .
CMD ["cp opt/* /usr/bin/","cilium install --chart-directory charts/cilium --helm-set kubeProxyReplacement=strict,k8sServiceHost=apiserver.cluster.local,k8sServicePort=6443"]
