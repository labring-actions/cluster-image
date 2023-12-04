FROM scratch
COPY charts charts
COPY registry registry
ARG TOOLS_VERSION="0.2.2-beta.5"
CMD ["helm upgrade --install kb-gemini charts/gemini --set image.oteld.tag=${TOOLS_VERSION} --insecure-skip-tls-verify -n kb-system --create-namespace"]