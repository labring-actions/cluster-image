FROM scratch
COPY charts charts
COPY registry registry
ENV METALLB_HELM_OPTS=${METALLB_HELM_OPTS:-""}
CMD ["helm upgrade --install metallb charts/metallb --namespace metallb-system --create-namespace $(METALLB_HELM_OPTS)"]