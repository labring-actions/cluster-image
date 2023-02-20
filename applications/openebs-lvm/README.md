## Overview

**[lvm-localpv](https://github.com/openebs/lvm-localpv)** is a performance optimised "Container Attached Storage" (CAS) solution of the CNCF project [**OpenEBS**](https://openebs.io/). The goal of OpenEBS is to extend Kubernetes with a declarative data plane, providing flexible persistent storage for stateful applications.

Design goals for Mayastor include:

- Highly available, durable persistence of data
- To be readily deployable and easily managed by autonomous SRE or development teams
- To be a low-overhead abstraction for NVMe-based storage devices

## Install
```
sealos run labring/openebs-lvm:v1.0.1
```

## Usage
[configure-mayastor](https://mayastor.gitbook.io/introduction/quickstart/configure-mayastor)
[deploy-a-test-application](https://mayastor.gitbook.io/introduction/quickstart/deploy-a-test-application)
