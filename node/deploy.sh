#!/bin/bash
docker build -t gcr.io/cloud-devrel-kokoro-resources/nodejs-test .
docker push gcr.io/cloud-devrel-kokoro-resources/nodejs-test
