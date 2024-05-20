FROM scratch
COPY charts charts
COPY registry registry
ENV SPIDERPOOL_HELM_OPTS=${SPIDERPOOL_HELM_OPTS:-""}
CMD ["helm upgrade --install spiderpool charts/spiderpool --namespace kube-system --create-namespace $(SPIDERPOOL_HELM_OPTS)"]