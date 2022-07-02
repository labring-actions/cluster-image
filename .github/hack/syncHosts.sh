#!/bin/bash

sed -i "/# GitHub520 Host Start/Q" /etc/hosts && curl https://raw.hellogithub.com/hosts >> /etc/hosts
sed -i '/^</d' /etc/hosts
