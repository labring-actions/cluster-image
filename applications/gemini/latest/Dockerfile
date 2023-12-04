FROM scratch
COPY charts charts
COPY registry registry
ARG TOOLS_VERSION="0.2.2-beta.5"
ENV NAME=${NAME:-"kb-gemini"}
ENV NAMESPACE=${NAMESPACE:-"kb-system"}
ENV HELM_OPTS=${HELM_OPTS:-""}
CMD ["helm upgrade --install $(NAME) charts/gemini --set image.oteld.tag=${TOOLS_VERSION} -n $(NAMESPACE) --create-namespace $(HELM_OPTS)"]