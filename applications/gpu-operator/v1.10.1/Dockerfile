FROM scratch
ENV TOOLKIT_VERSION=false
COPY . .
CMD ["helm install --wait --generate-name -n gpu-operator --create-namespace gpu-operator-v1.10.1.tgz --set driver.enabled=false --set toolkit.enabled=$(TOOLKIT_VERSION)"]
