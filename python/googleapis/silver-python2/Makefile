.PHONY: build
build:
	docker build -t gcr.io/silver-python2/python-worker:${TAG} .

.PHONY: publish
publish: build
	docker push gcr.io/silver-python2/python-worker:${TAG}
