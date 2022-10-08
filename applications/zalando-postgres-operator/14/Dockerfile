FROM scratch
COPY . .
CMD ["helm upgrade -i postgres-operator charts/postgres-operator --namespace=postgres --create-namespace","helm upgrade -i postgres-operator-ui charts/postgres-operator-ui --namespace=postgres --create-namespace --set service.type=NodePort","kubectl -n postgres create -f manifests/minimal-postgres-manifest.yaml"]
