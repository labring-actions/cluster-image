FROM scratch
COPY charts charts
COPY registry registry
ENV LOGTO_HELM_OPTS=${LOGTO_HELM_OPTS:-""}
CMD ["helm upgrade --install logto charts/logto --namespace kb-cloud --create-namespace $(LOGTO_HELM_OPTS)"]