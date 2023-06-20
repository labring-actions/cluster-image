FROM scratch
COPY . .
ENV password_valuespath="charts/openIM/configmap-password.values.yaml"
CMD ["helm upgrade openim charts/openIM --namespace openim-system --create-namespace --values charts/openIM/values.yaml --values charts/openIM/configmap-config.values.yaml --values charts/openIM/configmap-notification.values.yaml --values $password_valuespath"]
