FROM scratch
COPY charts charts
COPY registry registry
COPY opt/kbcli opt/kbcli
CMD ["kubectl create -f charts/kubeblocks/crds/kubeblocks_crds.yaml || kubectl replace -f charts/kubeblocks/crds/kubeblocks_crds.yaml","helm upgrade -i kubeblocks charts/kubeblocks --set snapshot-controller.enabled=false --insecure-skip-tls-verify -n kb-system --create-namespace","cp -rf opt/kbcli /usr/bin/"]
