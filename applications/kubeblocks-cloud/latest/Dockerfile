FROM scratch
COPY charts charts
COPY registry registry
CMD ["helm upgrade -i kubeblocks-cloud charts/kubeblocks-cloud --insecure-skip-tls-verify -n kubeblocks-cloud --create-namespace"]
