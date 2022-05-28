FROM scratch
COPY .. .
CMD ["kubectl create ns monitoring", "helm install kafka-exporter kafka-exporter"]
