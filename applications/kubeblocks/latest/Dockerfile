FROM scratch
COPY opt/kbcli /usr/local/bin/
COPY charts charts
COPY registry registry
CMD ["helm upgrade -i kubeblocks charts/kubeblocks --set snapshot-controller.enabled=false --insecure-skip-tls-verify -n kb-system --create-namespace"]
