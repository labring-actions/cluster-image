FROM scratch
COPY .. .
CMD ["helm upgrade skywalking skywalking -n skywalking --install  --create-namespace --set oap.image.tag=8.8.1 --set oap.storageType=elasticsearch --set ui.image.tag=8.8.1 --set elasticsearch.imageTag=6.8.6"]
