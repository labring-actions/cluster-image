#!/bin/bash
helm repo add oracle-mysql-operator https://mysql.github.io/mysql-operator/
helm pull oracle-mysql-operator/mysql-operator --version 2.0.6 --untar -d charts/
helm pull oracle-mysql-operator/mysql-innodbcluster --version 2.0.6 --untar -d charts/

arch=${1:-amd64}
echo "download oracle-mysql-operator success"
