FROM scratch
COPY charts charts
COPY registry registry
ENV OCEANBASE_HELM_OPTS=${OCEANBASE_HELM_OPTS:-""}
CMD ["helm upgrade --install oceanbase charts/oceanbase --namespace kb-system --create-namespace $(OCEANBASE_HELM_OPTS)"]