FROM scratch
COPY charts charts
COPY registry registry
ENV METRICS_SERVER_HELM_OPTS=${METRICS_SERVER_HELM_OPTS:-""}
CMD ["helm upgrade --install metrics-server charts/metrics-server --namespace metrics-server --create-namespace $(METRICS_SERVER_HELM_OPTS)"]