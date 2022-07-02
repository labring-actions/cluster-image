FROM scratch
COPY manifests ./manifests
CMD ["kubectl apply -f manifests/dashboard.yaml", "kubectl apply -f manifests/user.yaml", "echo -e \"You can login through this TOKEN\n--------------------------------\n$(kubectl -n kubernetes-dashboard create token admin-user)\n--------------------------------\""]
