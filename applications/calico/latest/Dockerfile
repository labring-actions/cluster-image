FROM scratch
COPY charts charts
COPY registry registry
ENV CALICO_HELM_OPTS=${CALICO_HELM_OPTS:-""}
CMD ["helm upgrade --install calico charts/ --namespace kube-system --create-namespace $(CALICO_HELM_OPTS)"]