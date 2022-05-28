FROM scratch
COPY .. .
CMD ["kubectl create ns kafka","kubectl apply -f kafka/crd.yaml","kubectl apply -f kafka/kafka.yaml"]
