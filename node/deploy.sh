#!/bin/bash
docker build -t gcr.io/cloud-devrel-kokoro-resources/node:6-user 6-user
docker build -t gcr.io/cloud-devrel-kokoro-resources/node:8-user 8-user
docker build -t gcr.io/cloud-devrel-kokoro-resources/node:10-user 10-user
docker build -t gcr.io/cloud-devrel-kokoro-resources/node:11-user 11-user

docker push gcr.io/cloud-devrel-kokoro-resources/node
