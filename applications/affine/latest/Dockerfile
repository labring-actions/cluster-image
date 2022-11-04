FROM scratch
COPY ./manifests ./affine
COPY ./registry ./registry
CMD ["kubectl apply -f affine/affine.yaml"]
