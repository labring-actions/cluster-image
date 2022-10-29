#!/bin/bash
git clone https://github.com/labring/sealos.git
cp -rf sealos/controllers/infra/deploy/* .
rm -rf sealos
tree -L 3
mv Dockerfile Kubefile
