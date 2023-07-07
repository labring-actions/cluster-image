ARG goVersion=1.20.4

# FROM node:18 AS buildhtml
# ARG ARCH
# WORKDIR /root
# COPY html .
# RUN yarn install
# RUN yarn run build

FROM golang:$goVersion AS go-env
RUN CGO_ENABLED=0 go install -ldflags="-w -s" -trimpath github.com/nsf/gocode@latest && \
    CGO_ENABLED=0 go install -ldflags="-w -s" -trimpath golang.org/x/tools/cmd/goimports@latest && \
    CGO_ENABLED=0 go install -ldflags="-w -s" -trimpath github.com/rogpeppe/godef@latest && \
    CGO_ENABLED=0 go install -ldflags="-w -s" -trimpath golang.org/x/tools/cmd/gorename@latest && \
    CGO_ENABLED=0 go install -ldflags="-w -s" -trimpath github.com/kisielk/errcheck@latest && \
    CGO_ENABLED=0 go install -ldflags="-w -s" -trimpath github.com/go-delve/delve/cmd/dlv@latest && \
    CGO_ENABLED=0 go install -ldflags="-w -s" -trimpath golang.org/x/tools/gopls@latest && \
    GO111MODULE=on

FROM mysql:8.0.30 AS mysql-client
FROM mongo:5.0.14-focal AS mongo-client
FROM redis:7.0.6-alpine AS redis-client
#FROM scratch
FROM golang:$goVersion
LABEL org.opencontainers.image.authors="labring"

USER root
ENV HOME /root
ARG kubeVersion=1.25.6
ARG ttydVersion=1.7.3
ARG helmVersion=3.12.0
ARG ARCH=amd64

WORKDIR /root
COPY ./inline.html ./index.html
COPY vim/ .
COPY scripts/start-terminal.sh /usr/bin/
COPY scripts/ttyd-kubectl.sh /usr/bin/
COPY --from=go-env /go/bin/* /usr/local/go/bin/

# install pagkages
RUN arch && \
    wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt bullseye-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    apt-get update && \
    apt-get install -y --no-install-recommends -o Acquire::http::No-Cache=True \
    ca-certificates curl wget bind9-utils git g++ gcc libc6-dev make pkg-config vim \
    ncurses-dev libtolua-dev exuberant-ctags gdb postgresql-client-14 dnsutils iputils-ping net-tools && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    chmod a+x /usr/bin/ttyd-kubectl.sh && \
    bash /usr/bin/ttyd-kubectl.sh && \
    vim +PlugInstall +qall && \
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
