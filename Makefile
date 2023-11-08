# Copyright ApeCloud, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

################################
# Prerequisites
################################
export GO111MODULE = auto
#export GOPROXY = https://goproxy.cn
export GOSUMDB = sum.golang.org
export GONOPROXY = github.com/apecloud
export GONOSUMDB = github.com/apecloud
export GOPRIVATE = github.com/apecloud
export LD_LIBRARY_PATH=$(abspath ./third_party/libbpf/lib/lib64):$(abspath ./third_party/bcc/lib/lib)

# Setting SHELL to bash allows bash commands to be executed by recipes.
# This is a requirement for 'setup-envtest.sh' in the test target.
# Options are set to exit when a recipe line exits non-zero or a piped command fails.
SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec

GO ?= go
GOOS ?= $(shell $(GO) env GOOS)
GOARCH ?= $(shell $(GO) env GOARCH)
# Get the currently used golang install path (in GOPATH/bin, unless GOBIN is set)
ifeq (,$(shell $(GO) env GOBIN))
GOBIN=$(shell $(GO) env GOPATH)/bin
else
GOBIN=$(shell $(GO) env GOBIN)
endif

################################
# Variables
################################
BUILDX_ENABLED ?= false
ifneq ($(BUILDX_ENABLED), false)
	ifeq ($(shell docker buildx inspect 2>/dev/null | awk '/Status/ { print $$2 }'), running)
		BUILDX_ENABLED ?= true
	else
		BUILDX_ENABLED ?= false
	endif
endif

GO_VERSION = 1.21
BUILDX_PLATFORMS ?= linux/amd64,linux/arm64
BUILDX_ARGS =
DOCKER_BUILD_ARGS ?= --build-arg="GO_VERSION=$(GO_VERSION)"

DOCKER_NO_BUILD_CACHE ?= false
ifeq ($(DOCKER_NO_BUILD_CACHE), true)
	DOCKER_BUILD_ARGS += --no-cache
endif

VERSION ?= 0.0.1

DOCKERFILE_PATH ?= ./Dockerfile
DOCKER_REPO ?= apecloud
DOCKER_IMAGE_NAME ?= kubeblocks-airgap
DOCKER_IMAGE_TAG = ${VERSION}
IMG ?= docker.io/$(DOCKER_REPO)/$(DOCKER_IMAGE_NAME)
TAG_LATEST ?= false


.PHONY: push-image
push-image: ## Push container image.
ifneq ($(BUILDX_ENABLED), true)
ifeq ($(TAG_LATEST), true)
	docker push $(IMG):latest
else
	docker push $(IMG):$(DOCKER_IMAGE_TAG)
endif
else
ifeq ($(TAG_LATEST), true)
	docker buildx build . -f $(DOCKERFILE_PATH) $(DOCKER_BUILD_ARGS) --platform $(BUILDX_PLATFORMS) -t $(IMG):latest --push $(BUILDX_ARGS)
else
	docker buildx build . -f $(DOCKERFILE_PATH) $(DOCKER_BUILD_ARGS) --platform $(BUILDX_PLATFORMS) -t $(IMG):$(DOCKER_IMAGE_TAG) --push $(BUILDX_ARGS)
endif
endif

.PHONY: apps
apps: ## Push container image.
	bash .github/scripts/apps.sh
