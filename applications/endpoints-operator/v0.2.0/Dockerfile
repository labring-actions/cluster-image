FROM scratch
COPY charts ./charts
COPY images ./images
COPY registry ./registry
CMD ["helm upgrade -n kube-system  endpoints-operator charts/endpoints-operator --install"]
