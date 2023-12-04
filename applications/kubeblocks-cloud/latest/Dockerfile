FROM scratch
COPY charts charts
COPY registry registry
ENV NAME=${NAME:-"kb-cloud"}
ENV NAMESPACE=${NAMESPACE:-"kb-cloud"}
ENV HELM_OPTS=${HELM_OPTS:-""}
CMD ["helm upgrade --install $(NAME) charts/kubeblocks-cloud --namespace $(NAMESPACE) --create-namespace -f charts/kubeblocks-cloud/kubeblocks-cloud-values.yaml $(HELM_OPTS)"]
