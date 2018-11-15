.PHONY: build
build:
	docker build -t googleapis/nox:${TAG} .

.PHONY: publish
publish: build
	docker push googleapis/nox:${TAG}
