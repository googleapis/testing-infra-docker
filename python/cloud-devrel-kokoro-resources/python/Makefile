.PHONY: build
build:
	docker build -t gcr.io/cloud-devrel-kokoro-resources/python:${TAG} .
	docker tag gcr.io/cloud-devrel-kokoro-resources/python:${TAG} gcr.io/cloud-devrel-public-resources/python:${TAG}

.PHONY: publish
publish: build
	gcloud docker -- push gcr.io/cloud-devrel-kokoro-resources/python:${TAG}
	gcloud docker -- push gcr.io/cloud-devrel-public-resources/python:${TAG}
