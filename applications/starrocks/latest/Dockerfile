FROM scratch
COPY charts charts
COPY registry registry
ENV STARROCKS_HELM_OPTS=${STARROCKS_HELM_OPTS:-""}
CMD ["helm upgrade --install starrocks charts/starrocks --namespace kb-system --create-namespace $(STARROCKS_HELM_OPTS)"]