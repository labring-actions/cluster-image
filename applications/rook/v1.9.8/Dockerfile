FROM scratch
COPY . .
CMD ["helm install --create-namespace --namespace rook-ceph rook-ceph rook-ceph","helm install --create-namespace --namespace rook-ceph rook-ceph-cluster --set operatorNamespace=rook-ceph rook-ceph-cluster"]
