FROM scratch
COPY charts charts
COPY registry registry
ARG TOOLS_VERSION="0.2.2-beta.5"
ENV GEMINI_HELM_OPTS=${GEMINI_HELM_OPTS:-""}
CMD ["helm upgrade --install kb-gemini charts/gemini --set image.oteld.tag=${TOOLS_VERSION} --namespace kb-system --create-namespace $(GEMINI_HELM_OPTS)"]