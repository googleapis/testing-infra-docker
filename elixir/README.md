# Elixir Docker Images

This directory contains the Docker images for running Elixir tests for the
Google API toolchains. The primary use case for this images is to run tests
on Kokoro via Trampoline.

## Supported Versions

Our Elixir client libraries currently support Elixir 1.6+.

## Building Images

You can build all of the test images by running:

    gcloud builds submit --config=cloudbuild.yaml .

You can publish the images by running:

    gcloud builds submit --project=cloud-devrel-kokoro-resources \
        --config=cloudbuild.yaml --machine-type=e2-highcpu-8 .
