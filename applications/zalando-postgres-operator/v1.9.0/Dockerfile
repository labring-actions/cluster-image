FROM scratch
COPY . .
CMD ["helm upgrade -i postgres-operator charts/postgres-operator --namespace=postgres --create-namespace","kubectl -n postgres create -f manifests/minimal-postgres-manifest.yaml"]
