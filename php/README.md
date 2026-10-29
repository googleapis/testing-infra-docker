# php-release
> The docker image for running PHP release Kokoro builds for Cloud repositories.

## Docker Registry
The release image for PHP is built from `php/release/Dockerfile`.

## Questions
Please reach out to `php-cloud@google.com` with any questions!

## Building Images

You can build and test the image by running:

    gcloud builds submit --config=cloudbuild-test.yaml .
