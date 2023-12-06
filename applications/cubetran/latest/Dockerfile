FROM scratch
COPY charts charts
COPY registry registry
ENV CUBETRAN_HELM_OPTS=${CUBETRAN_HELM_OPTS:-""}
CMD ["helm upgrade --install cubetran charts/cubetran --namespace kb-cubetran --create-namespace $(CUBETRAN_HELM_OPTS)"]