FROM scratch
COPY registry ./registry
COPY manifests ./manifests
COPY kuboard.sh kuboard.sh
CMD ["kubectl apply -f manifests/kuboard-v3.yaml","bash kubegems.sh"]
