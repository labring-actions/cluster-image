FROM scratch
COPY charts charts
COPY registry registry
ENV HELM_OPTS=${HELM_OPTS:-""}
CMD ["helm upgrade --install cubetran charts/cubetran -n kb-cubetran --create-namespace $(HELM_OPTS)"]