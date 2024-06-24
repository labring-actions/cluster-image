FROM scratch
COPY charts charts
COPY registry registry
ENV ZALANDO_HELM_OPTS=${ZALANDO_HELM_OPTS:-""}
CMD ["helm upgrade --install postgres-operator charts/postgres-operator --namespace zalando --create-namespace $(ZALANDO_HELM_OPTS)"]