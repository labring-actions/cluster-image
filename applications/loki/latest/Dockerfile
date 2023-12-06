FROM scratch
COPY charts charts
COPY registry registry
ENV LOKI_HELM_OPTS=${LOKI_HELM_OPTS:-""}
CMD ["helm upgrade --install loki charts/loki --namespace kb-cloud --create-namespace $(LOKI_HELM_OPTS)"]