#!/bin/bash
git clone https://github.com/labring/sealos.git
cp -rf sealos/controllers/app/deploy/* .
rm -rf sealos
tree -L 3
