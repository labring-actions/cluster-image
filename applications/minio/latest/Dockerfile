FROM scratch
COPY charts charts
COPY registry registry
ENV HELM_OPTS=${HELM_OPTS:-""}
CMD ["helm upgrade --install minio charts/minio --namespace minio --set service.type=NodePort --set consoleService.type=NodePort --set rootUser=admin --set rootPassword=minio123 --set buckets[0].name=kb-bucket,buckets[0].policy=none,buckets[0].purge=false --set mode=standalone --set resources.requests.memory=512Mi --set replicas=1 --create-namespace  $(HELM_OPTS)"]