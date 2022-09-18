SOURCE_DIR := $(abspath $(dir $(lastword ${MAKEFILE_LIST})))
MODELS_DIR := ${SOURCE_DIR}/models

DOCKER_DIR := ${SOURCE_DIR}/docker
DOCKER_CONFIG_TPL_DIR := ${DOCKER_DIR}/templates

# Variables
PYTHONPATH ?= ${SOURCE_DIR}/src
MODEL_NAME ?= "smart-recycling"
CONFIG_FILE ?= "config.json"
MODEL_LABEL ?= "test"

.PHONY: env
env-%: env
	if [ -z '${${*}}' ]; then echo 'Environment variable $* not set.' && exit 1; fi

.PHONY: dockerize-model
dockerize-model: ${MODELS_DIR}/${MODEL_NAME}/${MODEL_VERSION}/model-serving.config
dockerize-model: DOCKER_VERSION = ${MODEL_VERSION}
dockerize-model:
	docker buildx build --no-cache --platform linux/amd64 \
		--tag model-smart-recycling:${DOCKER_VERSION} \
		--build-arg MODEL_NAME=${MODEL_NAME} \
		--build-arg MODEL_VERSION=${MODEL_VERSION} \
		--file ${DOCKER_DIR}/Dockerfile.model \
		.

%/model-serving.config:
	sed -e "s/{{model_name}}/${MODEL_NAME}/g" \
		-e "s/{{model_version}}/${MODEL_VERSION}/g" \
		-e "s/{{model_label}}/${MODEL_LABEL}/g" \
		 ${DOCKER_CONFIG_TPL_DIR}/model-serving.config.tpl > $@
