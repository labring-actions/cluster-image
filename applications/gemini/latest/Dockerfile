FROM scratch
COPY charts charts
COPY registry registry
ARG TOOLS_VERSION="0.2.2-beta.5"
ENV HELM_OPTS=${HELM_OPTS:-""}
CMD ["helm upgrade --install kb-gemini charts/gemini --set image.oteld.tag=${TOOLS_VERSION} -n kb-system --create-namespace $(HELM_OPTS)"]