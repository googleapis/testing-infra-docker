# Go Docker Images

This directory contains the Docker images for running Go tests for the Google API toolchains.
The primary use case for this images is to run tests on Kokoro via Trampoline.

## Building Images

You can build all of the test images by running:

```shell
gcloud builds submit --config=cloudbuild.yaml .
```

You can publish the images by running:

```shell
# first, auth. make sure you're in the cloud-dpe-testing-working-group googlegroup to have access
gcloud auth login
gcloud builds submit \
    --timeout 1h \
    --project=cloud-devrel-kokoro-resources \
    --config=go/cloudbuild.yaml .
```

## Updating python requirements

- Install base-tooling-requirements.txt: `pip install --require-hashes -r base-tooling-requirements.txt`
- Add everything required to `requirements.in`
- Generate `requirements.txt`: `pip-compile requirements.in --generate-hashes`
