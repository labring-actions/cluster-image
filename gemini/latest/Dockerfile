FROM scratch
COPY charts charts
COPY registry registry
ARG KUBEBLOCKS_VERSION="latest"
CMD ["helm upgrade -i gemini charts/gemini --insecure-skip-tls-verify -n kb-system --create-namespace --set kubeblocks.version=${KUBEBLOCKS_VERSION},kubeblocks.namespace=kb-system,kubeblocks.serviceAccountName=kubeblocks"]
