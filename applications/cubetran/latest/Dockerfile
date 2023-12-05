FROM scratch
COPY charts charts
COPY registry registry
ENV HELM_OPTS=${HELM_OPTS:-""}
CMD ["helm upgrade --install kb-gemini charts/gemini -n kb-system --create-namespace $(HELM_OPTS)"]