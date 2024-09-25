FROM bitnami/kubectl:latest
ARG SSL_KEYSTORE_PASSWORD
USER root

RUN apt-get update && apt-get install -y curl && ln -s /usr/bin/curl /usr/local/bin/curl

USER 1001

CMD [ "kubectl" ]