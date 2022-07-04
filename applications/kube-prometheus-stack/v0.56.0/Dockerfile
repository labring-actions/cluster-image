FROM scratch
COPY . .
CMD ["helm install kube-prometheus-stack-35.0.0.tgz  --create-namespace --namespace prometheus --generate-name --values kube-prometheus-stack.values"]
