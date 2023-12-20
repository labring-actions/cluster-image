FROM scratch
COPY charts charts
COPY registry registry
ENV INGRESS_NGINX_HELM_OPTS=${INGRESS_NGINX_HELM_OPTS:-""}
CMD ["helm upgrade --install ingress-nginx charts/ingress-nginx --namespace ingress-nginx --create-namespace $(INGRESS_NGINX_HELM_OPTS)"]