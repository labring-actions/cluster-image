FROM scratch
COPY charts charts
COPY registry registry
ENV VMCLUSTER_HELM_OPTS=${VMCLUSTER_HELM_OPTS:-""}
CMD ["helm upgrade --install vmcluster charts/victoria-metrics-cluster --namespace kb-cloud --create-namespace $(VMCLUSTER_HELM_OPTS)"]