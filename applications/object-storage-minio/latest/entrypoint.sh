kubectl apply -f manifests/minio.yaml

curl https://dl.min.io/client/mc/release/linux-amd64/mc --create-dirs -o $HOME/minio-binaries/mc
chmod +x $HOME/minio-binaries/mc
export PATH=$PATH:$HOME/minio-binaries/

MINIO_EXTERNAL_ENDPOINT="https://objectstorageapi.dev.sealos.top"
MINIO_ADMIN_ACCESS_KEY=$(kubectl -n objectstorage-system get secret object-storage-sealos-user-0 -o jsonpath="{.data.CONSOLE_ACCESS_KEY}" | base64 --decode)
MINIO_ADMIN_SECRET_KEY=$(kubectl -n objectstorage-system get secret object-storage-sealos-user-0 -o jsonpath="{.data.CONSOLE_SECRET_KEY}" | base64 --decode)

mc alias set objectstorage ${MINIO_EXTERNAL_ENDPOINT} ${MINIO_ADMIN_ACCESS_KEY} ${MINIO_ADMIN_SECRET_KEY}

mc admin policy create objectstorage userNormal /tmp/user_deny_write.json
mc admin policy create objectstorage userDenyWrite /tmp/user_deny_write.json
mc admin policy create objectstorage migration /tmp/migration.json

mc admin user add objectstorage migration sealos.12345
mc admin group add objectstorage userNormal
mc admin group add objectstorage userDenyWrite
mc admin policy attach objectstorage migration --user migration
mc admin policy attach objectstorage userNormal --group userNormal
mc admin policy attach objectstorage userDenyWrite --group userDenyWrite