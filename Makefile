REPO = getupcloud
NAME = database-backup
VERSION = v2.3

all: build

build:
	docker build -t ${REPO}/${NAME}:${VERSION} .

tag-latest:
	docker tag ${REPO}/${NAME}:${VERSION} ${REPO}/${NAME}:latest

push:
	docker push ${REPO}/${NAME}:${VERSION}

push-latest:
	docker push ${REPO}/${NAME}:latest
