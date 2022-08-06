FROM scratch
COPY . .
ENV IFACE "eth.*|en.*"
CMD ["IFACE=\"$(IFACE)\" bash ovn-install.sh"]
