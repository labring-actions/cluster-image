FROM mysql:8.0.30 AS mysql-client
FROM mongo:5.0.14-focal AS mongo-client
FROM redis:7.0.6 AS redis-client
# FROM postgres:14 AS psql-client
#FROM scratch
FROM ubuntu:20.04
LABEL org.opencontainers.image.authors="labring"

USER root
ENV HOME /root
ARG kubeVersion=1.25.6
ARG ttydVersion=1.7.3
ARG helmVersion=3.12.0
ARG ARCH
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /root
COPY ./inline.html ./index.html
COPY vim/ .
COPY scripts/start-terminal.sh /usr/bin/
COPY scripts/ttyd-kubectl.sh /usr/bin/

RUN arch                                                                                                                        && \
    apt-get update                                                                                                              && \
    apt-get install -y --no-install-recommends -o Acquire::http::No-Cache=True                                                     \
    ca-certificates curl wget bind9-utils git g++ gcc libc6-dev make pkg-config vim                                                \
    ncurses-dev libtolua-dev exuberant-ctags gdb dnsutils iputils-ping net-tools postgresql-client openssh-client               && \
    apt-get clean && rm -rf /var/lib/apt/lists/*                                                                                && \
    chmod a+x /usr/bin/ttyd-kubectl.sh                                                                                          && \
    bash /usr/bin/ttyd-kubectl.sh                                                                                               && \
    vim +PlugInstall +qall                                                                                                      && \
    chmod a+x /usr/bin/start-terminal.sh

COPY --from=mysql-client /usr/bin/mysql /usr/bin/mysql
COPY --from=mongo-client /usr/bin/mongosh /usr/bin/mongosh
COPY --from=redis-client /usr/local/bin/redis-cli /usr/local/bin/redis-cli

ENV USER_TOKEN ""
ENV APISERVER "https://apiserver.cluster.local:6443"
ENV USER_NAME "admin"
ENV NAMESPACE "default"

EXPOSE 8080

CMD ["sh","/usr/bin/start-terminal.sh"]
