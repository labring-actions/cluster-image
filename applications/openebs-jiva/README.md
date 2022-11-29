## Prerequisites

Just need: iSCSI initiator utils installed on all the worker nodes

See: [jiva-prerequisites](https://openebs.io/docs/user-guides/jiva/jiva-prerequisites)

## Install
```
sealos run labring/openebs-jiva:v3.3.0
```

## Test
Create sample pods with pvc.
```
$ cat busybox.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: busybox
  labels:
    app: busybox
spec:
  replicas: 1
  strategy:
    type: RollingUpdate
  selector:
    matchLabels:
      app: busybox
  template:
    metadata:
      labels:
        app: busybox
    spec:
      containers:
      - resources:
          limits:
            cpu: 0.5
        name: busybox
        image: busybox
        command: ['sh', '-c', 'echo Container 1 is Running ; sleep 3600']
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 3306
          name: busybox
        volumeMounts:
        - mountPath: /var/lib/mysql
          name: demo-vol1
      volumes:
      - name: demo-vol1
        persistentVolumeClaim:
          claimName: example-jiva-csi-pvc
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: example-jiva-csi-pvc
spec:
  storageClassName: openebs-jiva-csi-sc
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 4Gi
```

```
kubectl apply -f busybox.yaml
```
