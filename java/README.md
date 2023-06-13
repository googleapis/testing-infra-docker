# Java Docker Images

This directory contains the Docker images for running Java tests for the
Google API toolchains. The primary use case for this images is to run tests
on Kokoro via Trampoline.

## Supported Versions

Our Java client libraries currently support Java 8+.

## Supported Tools

* gcloud SDK
* Maven 3.*
* Gradle 4.9

## Building Images

You can build all of the test images by running:

    gcloud builds submit --config=cloudbuild.yaml .

You can publish the images by running:

    gcloud builds submit --project=cloud-devrel-kokoro-resources --config=cloudbuild.yaml .
