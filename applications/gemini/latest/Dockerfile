FROM scratch
COPY charts charts
COPY registry registry
ENV GEMINI_HELM_OPTS=${GEMINI_HELM_OPTS:-""}
CMD ["helm upgrade --install kb-gemini charts/gemini --namespace kb-system --create-namespace $(GEMINI_HELM_OPTS)"]