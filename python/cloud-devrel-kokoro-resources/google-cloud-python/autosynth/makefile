IMAGENAME=google-cloud-python/autosynth
TAG=latest

.PHONY: build
build:
	docker build -t gcr.io/cloud-devrel-kokoro-resources/${IMAGENAME}:${TAG} .
	#docker tag gcr.io/cloud-devrel-kokoro-resources/${IMAGENAME}:${TAG} gcr.io/cloud-devrel-public-resources/${IMAGENAME}:${TAG}
.PHONY: publish
publish: build
	gcloud docker -- push gcr.io/cloud-devrel-kokoro-resources/${IMAGENAME}:${TAG}
	#gcloud docker -- push gcr.io/cloud-devrel-public-resources/${IMAGENAME}:${TAG}
