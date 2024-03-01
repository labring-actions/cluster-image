FROM scratch
COPY charts charts
COPY registry registry
ENV CILIUM_HELM_OPTS=${CILIUM_HELM_OPTS:-""}
CMD ["helm upgrade --install cilium charts/cilium --namespace cilium-system --create-namespace $(CILIUM_HELM_OPTS)"]