FROM scratch
COPY charts charts
COPY registry registry
ENV MINIO_HELM_OPTS=${MINIO_HELM_OPTS:-""}
CMD ["helm upgrade --install minio charts/minio --namespace minio --create-namespace $(MINIO_HELM_OPTS)"]