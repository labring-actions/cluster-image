FROM scratch
COPY charts charts
COPY registry registry
ENV STARROCKS_CE_HELM_OPTS=${STARROCKS_CE_HELM_OPTS:-""}
CMD ["helm upgrade --install kb-addon-starrocks-ce charts/starrocks-ce --namespace kb-system --create-namespace $(STARROCKS_CE_HELM_OPTS)"]
