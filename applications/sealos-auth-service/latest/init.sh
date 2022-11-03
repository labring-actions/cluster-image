#!/bin/bash
git clone https://github.com/labring/sealos.git
cp -rf sealos/service/auth/deploy/* .
rm -rf sealos
tree -L 3
