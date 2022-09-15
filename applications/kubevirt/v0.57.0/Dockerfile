FROM scratch
COPY . .
CMD ["cp opt/virtctl /usr/local/bin/","kubectl apply -f manifests/kubevirt-operator.yaml","kubectl apply -f manifests/kubevirt-cr.yaml","kubectl apply -f manifests/cdi-operator.yaml","kubectl apply -f manifests/cdi-cr.yaml"]
