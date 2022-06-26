FROM scratch
COPY . .
CMD ["helm install elasticsearch elasticsearch -n elastic --create-namespace","helm install kibana kibana -n elastic --create-namespace"]
