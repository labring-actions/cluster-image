FROM scratch
COPY charts charts
COPY registry registry
ENV CLOUD_HELM_OPTS=${CLOUD_HELM_OPTS:-""}
CMD ["helm upgrade --install kb-cloud charts/kubeblocks-cloud --namespace kb-cloud --create-namespace $(CLOUD_HELM_OPTS)"]
