FROM scratch
COPY . .
CMD ["mv opt/kubectl-minio /usr/local/bin/", "kubectl minio init", "kubectl create ns minio","kubectl minio tenant create tenant1 --servers 4 --volumes 4 --capacity 100Gi --namespace minio"]
