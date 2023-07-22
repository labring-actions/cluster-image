** Please be patient while the chart is being deployed **

MinIO&reg; can be accessed via port  on the following DNS name from within your cluster:

bitnami-minio.minio.svc.cluster.local

To get your credentials run:

export ROOT_USER=$(kubectl get secret --namespace minio bitnami-minio -o jsonpath="{.data.root-user}" | base64 -d)
export ROOT_PASSWORD=$(kubectl get secret --namespace minio bitnami-minio -o jsonpath="{.data.root-password}" | base64 -d)

To connect to your MinIO&reg; server using a client:

- Run a MinIO&reg; Client pod and append the desired command (e.g. 'admin info'):

  kubectl run --namespace minio bitnami-minio-client \
  --rm --tty -i --restart='Never' \
  --env MINIO_SERVER_ROOT_USER=$ROOT_USER \
  --env MINIO_SERVER_ROOT_PASSWORD=$ROOT_PASSWORD \
  --env MINIO_SERVER_HOST=bitnami-minio \
  --image docker.io/bitnami/minio-client:2023.5.18-debian-11-r2 -- admin info minio

To access the MinIO&reg; web UI:

- Get the MinIO&reg; URL:

  echo "MinIO&reg; web URL: http://127.0.0.1:9001/minio"
  kubectl port-forward --namespace minio svc/bitnami-minio 9001:9001
