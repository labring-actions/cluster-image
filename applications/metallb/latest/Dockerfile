FROM scratch
COPY charts charts
COPY registry registry
ENV HELM_OPTS=${HELM_OPTS:-""}
CMD ["helm upgrade --install metallb charts/metallb --namespace metallb-system --create-namespace  $(HELM_OPTS)"]