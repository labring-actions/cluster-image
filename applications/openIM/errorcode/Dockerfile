FROM scratch
COPY . .
ENV password_valuespath="openIM/configmap-password.values.yaml"
CMD ["helm upgrade openim openIM --namespace openim-system --create-namespace --values openIM/values.yaml --values openIM/configmap-config.values.yaml --values openIM/configmap-notification.values.yaml --values $password_valuespath"]
