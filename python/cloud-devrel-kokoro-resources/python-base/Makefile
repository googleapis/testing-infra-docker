.PHONY: build
build:
	docker build -t gcr.io/cloud-devrel-kokoro-resources/python-base:${TAG} .
	docker tag gcr.io/cloud-devrel-kokoro-resources/python-base:${TAG} gcr.io/cloud-devrel-public-resources/python-base:${TAG}
.PHONY: publish
publish: build
	gcloud docker -- push gcr.io/cloud-devrel-kokoro-resources/python-base:${TAG}
	gcloud docker -- push gcr.io/cloud-devrel-public-resources/python-base:${TAG}
