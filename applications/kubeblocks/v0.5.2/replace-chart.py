#!/usr/bin/env python3
# -*- coding:utf-8 -*-

import re
import sys

oci_registry = "oci://zot.zot.svc.cluster.local:8443"

# Read all lines from the file
# with open('all.yaml') as f:
#     lines = f.readlines()

# read from stdin
lines = sys.stdin.readlines()

# Iterate over each line
for i, line in enumerate(lines):
    # If the line start with chartLocationURL
    if line.lstrip().startswith("chartLocationURL:"):
        # Replace chartLocationURL to oci registry
        line = re.sub(r'https://jihulab.com/api/v4/projects/85949/packages/helm/stable/charts',
                      oci_registry, line)

        # Remove version and tgz info in the chartLocationURL, and add extra helm install options
        splits = line.rsplit('-', 1)
        ver = splits[1].rsplit('.', 1)[0]
        line = splits[0] + """
    installOptions:
      insecure-skip-tls-verify: ""
      version: {}
""".format(ver)

    # write to stdout
    sys.stdout.write(line)
