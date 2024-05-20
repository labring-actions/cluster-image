FROM scratch
COPY charts charts
COPY registry registry
ENV APE_LOCAL_HELM_OPTS=${APE_LOCAL_HELM_OPTS:-""}
CMD ["helm upgrade --install ape-local charts/ape-local-csi-driver --namespace kb-system --create-namespace $(APE_LOCAL_HELM_OPTS)"]