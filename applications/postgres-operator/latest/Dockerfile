FROM scratch
COPY charts charts
COPY registry registry
ENV POSTGRES_OPERATOR_HELM_OPTS=${POSTGRES_OPERATOR_HELM_OPTS:-""}
CMD ["helm upgrade --install postgres-operator charts/postgres-operator --namespace postgres-operator --create-namespace $(POSTGRES_OPERATOR_HELM_OPTS)"]