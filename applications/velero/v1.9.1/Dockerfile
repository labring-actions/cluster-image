FROM scratch
COPY . .
CMD ["cp opt/velero /usr/local/bin/","velero install --plugins velero/velero-plugin-for-aws:v1.5.0 --namespace velero --default-volumes-to-restic --use-restic --use-volume-snapshots=false --no-default-backup-location --no-secret"]
