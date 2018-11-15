# nodejs-test
> The docker image for testing node.js.

This is a very, very simple image.  It uses `ubuntu:latest`, and installs `nvm`. That's about it.

## Docker Registry
This image is available at `gcr.io/cloud-devrel-kokoro-resources/nodejs-test`.  You can try it out by running:

```sh
$ docker run -it gcr.io/cloud-devrel-kokoro-resources/nodejs-test
```

## Usage

To use it, you need to run `nvm install` to choose your node.js version:

```sh
$ nvm install 10
```

## Questions

Please reach out to `node-team@google.com` with any questions!
