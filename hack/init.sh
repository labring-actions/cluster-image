#!/bin/bash
mkdir -p /etc/containers
cat > /etc/containers/policy.json << EOF
{
    "default": [
	{
	    "type": "insecureAcceptAnything"
	}
    ],
    "transports":
	{
	    "docker-daemon":
		{
		    "": [{"type":"insecureAcceptAnything"}]
		}
	}
}
EOF

cat > /etc/containers/storage.conf << EOF
[storage]
# Default Storage Driver, Must be set for proper operation.
driver = "overlay"
# Temporary storage location
runroot = "/run/containers/storage"
# Primary Read/Write location of container storage
# When changing the graphroot location on an SELINUX system, you must
# ensure  the labeling matches the default locations labels with the
# following commands:
# semanage fcontext -a -e /var/lib/containers/storage /NEWSTORAGEPATH
# restorecon -R -v /NEWSTORAGEPATH
graphroot = "/var/lib/containers/storage"
EOF
