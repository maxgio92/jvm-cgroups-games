SHELL := /usr/bin/env bash

IMAGE := jvm-cgroups-games
VERSION	:= 0.1.0
LOCAL_REGISTRY := localhost:5000

CPU_QUOTA ?= 1000
CPU_PERIOD ?= 1000
CPU_SHARES ?= 1

build:
	@docker build . -t $(IMAGE):$(VERSION)

tag:
	@docker tag $(IMAGE):$(VERSION) $(LOCAL_REGISTRY)/$(IMAGE):$(VERSION)

publish: publish/local

publish/local: build tag
	@docker push $(LOCAL_REGISTRY)/$(IMAGE):$(VERSION)

local-registry:
	@./scripts/create-local-registry.sh

kind: local-registry
	@./scripts/create-local-cluster.sh

deploy: local-registry kind
	@kubectl apply -f deploy.yaml

deploy/kubernetes: local-registry publish/local kind
	@kubectl apply -f deploy.yaml

deploy/docker:
	@docker run --rm $(IMAGE):$(VERSION)
	#@docker run --cpu-quota=$(CPU_QUOTA) --cpu-period=$(CPU_PERIOD) --rm $(IMAGE):$(VERSION)
	#@docker run --cpu-shares=$(CPU_SHARES) --rm $(IMAGE):$(VERSION)

deploy: deploy/kubernetes
