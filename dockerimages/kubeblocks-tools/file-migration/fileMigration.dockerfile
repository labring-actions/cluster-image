FROM ubuntu:22.04
LABEL org.opencontainers.image.authors="labring"

USER root
ENV HOME /root
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /root
COPY migration.sh /root/

RUN arch                                                                                                                        && \
    apt-get update --fix-missing                                                                                                             && \
    apt-get install -y --no-install-recommends -o Acquire::http::No-Cache=True                                                     \
    ca-certificates curl wget bind9-utils git g++ gcc libc6-dev make pkg-config vim                                                \
    ncurses-dev libtolua-dev exuberant-ctags gdb dnsutils iputils-ping net-tools mysql-server postgresql postgresql-contrib gnupg
RUN chmod a+x /root/migration.sh
RUN curl https://dl.min.io/client/mc/release/linux-amd64/mc --create-dirs -o /root/minio-binaries/mc
RUN curl -fsSL https://pgp.mongodb.com/server-6.0.asc | \
       gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg \
       --dearmor
RUN echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list
RUN apt-get update && apt-get install -y mongodb-org
CMD ["sh","/root/migration.sh"]