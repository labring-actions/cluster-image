FROM scratch
COPY charts charts
COPY registry registry
ENV RABBITMQ_HELM_OPTS=${RABBITMQ_HELM_OPTS:-""}
CMD ["helm upgrade --install rabbitmq charts/rabbitmq --namespace kb-system --create-namespace $(RABBITMQ_HELM_OPTS)"]