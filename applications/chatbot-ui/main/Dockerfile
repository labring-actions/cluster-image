FROM scratch
COPY ./manifests ./manifests
COPY ./registry ./registry
CMD ["kubectl apply -f manifests/chatbot-ui.yaml"]
