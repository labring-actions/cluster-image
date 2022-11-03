#!/bin/bash
git clone https://github.com/labring/sealos.git
cp -rf sealos/controllers/terminal/deploy/* .
rm -rf sealos
tree -L 3
