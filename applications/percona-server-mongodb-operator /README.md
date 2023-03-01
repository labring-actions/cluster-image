## Overview

Percona Server for MongoDB (PSMDB) is an open-source enterprise MongoDB solution that helps you to ensure data availability for your applications while improving security and simplifying the development of new applications in the most demanding public, private, and hybrid cloud environments.

Based on our best practices for deployment and configuration, Percona Operator for MongoDB contains everything you need to quickly and consistently deploy and scale Percona Server for MongoDB instances into a Kubernetes cluster on-premises or in the cloud. It provides the following capabilities:

Easy deployment with no single point of failure
Sharding support
Scheduled and manual backups
Integrated monitoring with Percona Monitoring and Management
Smart Update to keep your database software up to date automatically
Automated Password Rotation – use the standard Kubernetes API to enforce password rotation policies for system user
Private container image registries


## Install
```
sealos run labring/percona-server-mongodb-operator:main
```

## Reference
https://docs.percona.com/percona-operator-for-mongodb/index.html
