# php-test
> The docker images for running PHP Kokoro builds for Cloud repositories.

## Docker Registry
The images for individual versions of PHP are available at `gcr.io/cloud-devrel-kokoro-resources/php##`.
You can try them out by running:

```sh
$ docker run --rm -it gcr.io/cloud-devrel-kokoro-resources/php81
$ docker run --rm -it gcr.io/cloud-devrel-kokoro-resources/php82
$ docker run --rm -it gcr.io/cloud-devrel-kokoro-resources/php83
```

An image containing all [supported versions][php-version-support] of PHP is available
at `gcr.io/cloud-devrel-kokoro-resources/php`. You can try it out by running"

```sh
$ docker run --rm -it gcr.io/cloud-devrel-kokoro-resources/php
```

When using the image, switching between versions of PHP is done using [PHPBrew][phpbrew]:

```sh
# Switch to PHP 8.0
phpbrew switch $(phpbrew list | grep 8.0)
```

[php-version-support]: https://www.php.net/supported-versions.php
[phpbrew]: https://github.com/phpbrew/phpbrew

## Questions
Please reach out to `php-cloud@google.com` with any questions!


## Building Images

You can build all of the test images by running:

    gcloud builds submit --config=cloudbuild.yaml .

You can publish the images by running:

    gcloud builds submit --project=cloud-devrel-kokoro-resources --config=cloudbuild.yaml .
