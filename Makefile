SOURCE_DIR := $(abspath $(dir $(lastword ${MAKEFILE_LIST})))
MODELS_DIR := ${SOURCE_DIR}/models

DOCKER_DIR := ${SOURCE_DIR}/docker
DOCKER_CONFIG_TPL_DIR := ${DOCKER_DIR}/templates

# Variables
MODEL_NAME ?= "smart-recycling"
MODEL_VERSION ?= 1
MODEL_LABEL ?= "test"

.PHONY: env
env-%: env
	if [ -z '${${*}}' ]; then echo 'Environment variable $* not set.' && exit 1; fi

.PHONY: dockerize-model
dockerize-model: ${MODELS_DIR}/${MODEL_NAME}/${MODEL_VERSION}/model-serving.config
dockerize-model: DOCKER_VERSION = ${MODEL_VERSION}
dockerize-model:
	docker buildx build --no-cache --platform linux/amd64 \
		--tag ${MODEL_NAME}:${DOCKER_VERSION} \
		--build-arg MODEL_NAME=${MODEL_NAME} \
		--build-arg MODEL_VERSION=${MODEL_VERSION} \
		--file ${DOCKER_DIR}/Dockerfile.model \
		.

%/model-serving.config:
	sed -e "s/{{model_name}}/${MODEL_NAME}/g" \
		-e "s/{{model_version}}/${MODEL_VERSION}/g" \
		-e "s/{{model_label}}/${MODEL_LABEL}/g" \
		 ${DOCKER_CONFIG_TPL_DIR}/model-serving.config.tpl > $@

.PHONY: run
run:
	docker run -it --rm -p 8501:8501 ${MODEL_NAME}:${MODEL_VERSION} \
		--allow_version_labels_for_unavailable_models \
		--model_config_file=/models/models.config

.PHONY: lint
lint: install-lint-deps
	@echo "Linting..."
	@poetry run ruff check ./predict

.PHONY: format
format: install-lint-deps
	@echo "Formatting..."
	@poetry run ruff check --fix ./predict
	@poetry run ruff format ./predict

.PHONY: install-lint-deps
install-lint-deps:
	@echo "Installing lint dependencies..."
	@poetry install --only lint || true
