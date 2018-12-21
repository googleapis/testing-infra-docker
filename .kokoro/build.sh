#!/bin/bash

cd github/testing-infra-docker/${LANGUAGE}

gcloud builds submit --timeout 30m --config cloudbuild.yaml .
