FROM scratch
COPY charts charts
COPY registry registry
ENV GEMINI_MONITOR_HELM_OPTS=${GEMINI_MONITOR_HELM_OPTS:-""}
CMD ["helm upgrade --install kb-monitor charts/gemini-monitor --namespace kb-system --create-namespace $(GEMINI_MONITOR_HELM_OPTS)"]