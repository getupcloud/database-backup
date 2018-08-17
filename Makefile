REPO = getupcloud
NAME = database-backup
VERSION = v2.3

default: build

## Mandatory targets

.PHONY: build
build:
	docker build -t ${REPO}/${NAME}:${VERSION} .

.PHONY: tag-latest
tag:
	docker tag ${REPO}/${NAME}:${VERSION} ${REPO}/${NAME}:latest

.PHONY: push
push:
	docker push ${REPO}/${NAME}:${VERSION}

.PHONY: push-latest
push-latest:
	docker push ${REPO}/${NAME}:latest

## Project specific targets
