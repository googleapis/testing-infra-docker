#!/bin/bash

cd github/testing-infra-docker/{$LANGUAGE}

gcloud builds submit --config cloudbuild.yaml .