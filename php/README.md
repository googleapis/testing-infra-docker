# php-test
> The docker images for running PHP Kokoro builds for Cloud repositories.

## Docker Registry
This image is available at `gcr.io/cloud-devrel-kokoro-resources/php##`.  You can try it out by running:

```sh
$ docker run --rm -it gcr.io/cloud-devrel-kokoro-resources/php72
$ docker run --rm -it gcr.io/cloud-devrel-kokoro-resources/php73
$ docker run --rm -it gcr.io/cloud-devrel-kokoro-resources/php74
$ docker run --rm -it gcr.io/cloud-devrel-kokoro-resources/php80
```

## Questions
Please reach out to `php-cloud@google.com` with any questions!


## Building Images

You can build all of the test images by running:

    gcloud builds submit --config=cloudbuild.yaml .

You can publish the images by running:

    gcloud builds submit --project=cloud-devrel-kokoro-resources --config=cloudbuild.yaml .
