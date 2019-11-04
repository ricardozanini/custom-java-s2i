IMAGE_VERSION := $(shell cat image.yaml | egrep ^version  | cut -d"\"" -f2)
BUILD_ENGINE := docker
.DEFAULT_GOAL := build

# Build all images
.PHONY: build
build: springboot-ubi8 springboot-ubi8-s2i

springboot-ubi8:
	cekit -v build --overrides-file springboot-ubi8-overrides.yaml ${BUILD_ENGINE}

springboot-ubi8-s2i:
	cekit -v build --overrides-file springboot-ubi8-s2i-overrides.yaml ${BUILD_ENGINE}

# push images to quay.io, this requires permissions under kiegroup organization
.PHONY: push
push: build _push
_push:
	docker push quay.io/ricardozanini/springboot-ubi8:${IMAGE_VERSION}
	docker push quay.io/ricardozanini/springboot-ubi8:latest
	docker push quay.io/ricardozanini/springboot-ubi8-s2i:${IMAGE_VERSION}
	docker push quay.io/ricardozanini/springboot-ubi8-s2i:latest