# Go Docker images

This directory contains the Docker images for running Go tests for the Google API toolchains.
The primary use case for these images is to run tests on Kokoro via Trampoline.

## Running images

You can manually run the Docker images on Cloud Build:

```shell
gcloud builds submit --config=cloudbuild.yaml .
```

## Publishing images

You can manually publish the images:

```shell
# first, auth. make sure you're in the cloud-dpe-testing-working-group googlegroup to have access
gcloud auth login
gcloud builds submit \
    --timeout 1h \
    --project=cloud-devrel-kokoro-resources \
    --config=go/cloudbuild.yaml .
```
