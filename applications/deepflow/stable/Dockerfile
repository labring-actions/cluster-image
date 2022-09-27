FROM scratch
COPY . .
CMD ["mv opt/deepflow-ctl /usr/bin/","helm upgrade --install deepflow  charts/deepflow --namespace=deepflow --create-namespace"]
