FROM scratch
COPY . .
CMD ["helm install rancher rancher --namespace cattle-system --create-namespace --set hostname=rancher.my.org  --set bootstrapPassword=admin"]
