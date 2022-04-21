Dirs=$(shell ls)

PROJECT_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))
define go-get-tool
@[ -f $(1) ] || { \
set -e ;\
TMP_DIR=$$(mktemp -d) ;\
cd $$TMP_DIR ;\
go mod init tmp ;\
echo "Downloading $(2)" ;\
GOBIN=$(PROJECT_DIR)/bin go get $(2) ;\
rm -rf $$TMP_DIR ;\
}
endef


OSSUTIL_BIN = $(shell pwd)/bin/ossutil
install-ossutil: ## check license if not exist install go-lint tools
	$(call go-get-tool,$(OSSUTIL_BIN),github.com/aliyun/ossutil@latest)

upload-oss: install-ossutil
	tar -czvf cluster-image.tar.gz runtime hack
	$(OSSUTIL_BIN) cp -f cluster-image.tar.gz  oss://sealyun-home/images/cluster-image.tar.gz
	rm -rf cluster-image.tar.gz
