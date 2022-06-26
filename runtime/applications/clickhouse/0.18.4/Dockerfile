FROM scratch
COPY . .
CMD ["kubectl apply -f clickhouse/clickhouse-operator.yaml","kubectl apply -f clickhouse/cr.yaml"]
