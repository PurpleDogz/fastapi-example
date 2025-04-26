# Use some sensible default shell settings
SHELL := /bin/bash
.ONESHELL:
.SILENT:

ifndef IMAGE_NAME
IMAGE_NAME=uv-fastapi-example
endif

ifndef IMAGE_TAG
IMAGE_TAG=latest
endif

export IMAGE_NAME_TAG = ${IMAGE_NAME}:${IMAGE_TAG}
export IMAGE_NAME_TAG_LATEST = ${IMAGE_NAME}:latest

export REVISION
export DEFAULT_DOCKER_REPO

.PHONY: setup
setup:
	uv venv
	uv sync
	uv sync --extra dev

.PHONY: run
run:
	./.venv/Scripts/fastapi run

.PHONY: lint
lint:
	ruff check ./app

.PHONY: test
test:
	./.venv/Scripts/python -m pytest --log-cli-level INFO --cov -s ./app

.PHONY: build_image
build_image:
	docker build --tag ${IMAGE_NAME_TAG} \
				 --build-arg REVISION=${REVISION} \
				 --build-arg DOCKER_REPO=${DEFAULT_DOCKER_REPO} .

.PHONY: publish
publish:
	./publish-image.sh