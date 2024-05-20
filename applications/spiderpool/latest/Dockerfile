FROM scratch
COPY charts charts
COPY registry registry
ENV SPIDERPOOL_HELM_OPTS=${SPIDERPOOL_HELM_OPTS:-""}
CMD ["helm upgrade --install spiderpool charts/spiderpool --namespace kube-system --create-namespace --set multus.multusCNI.install=false --set spiderpoolAgent.image.registry=docker.io --set spiderpoolAgent.image.repository=apecloud/spiderpool-agent --set spiderpoolAgent.image.tag=eb82b45a097ad23906e72199b70e25d161fbe88d --set spiderpoolController.image.registry=docker.io --set spiderpoolController.image.repository=apecloud/spiderpool-controller --set spiderpoolController.image.tag=eb82b45a097ad23906e72199b70e25d161fbe88d $(SPIDERPOOL_HELM_OPTS)"]