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

## Updating python dependencies

The images contain Python dependencies that may be installed via pip. Security
considerations require that all pip commands enable checksums by passing the
`--require-hashes` option along with a requirements file.

See [#222](https://github.com/googleapis/testing-infra-docker/pull/222)
for more detail.

1. Obtain the latest version of `base-tooling-requirements.txt`. This content is available internally.
1. Install the Python tools dependencies, including `pip-compile`:

   ```sh
   pip install --require-hashes -r base-tooling-requirements.txt
   ```
2. Verify that the contents of `requirements.in` reflect the current dependencies required by the image. (These should be fairly stable.)
3. Re-generate `requirements.txt` from `requirements.in`:

   ```sh
   pip-compile requirements.in --generate-hashes
   ```
