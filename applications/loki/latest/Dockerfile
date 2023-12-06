FROM scratch
COPY charts charts
COPY registry registry
ENV HELM_OPTS=${HELM_OPTS:-""}
CMD ["helm upgrade --install loki charts/loki --namespace kb-cloud --create-namespace $(HELM_OPTS)"]