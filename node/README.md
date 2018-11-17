# nodejs-test
> The docker images for running Node.js Kokoro builds for Cloud client libraries.

Based on the [official](https://hub.docker.com/_/node/) Node.js community-maintained docker images.

Defaults to start container as user `node` because running `node` as root causes [issues](http://syskall.com/dont-run-node-dot-js-as-root/).

Also install `python3.7` and `pip3` to run Yoshi tools.

## Docker Registry

This image is available at `gcr.io/cloud-devrel-kokoro-resources/node`.  You can try it out by running:

```sh
$ docker run -it gcr.io/cloud-devrel-kokoro-resources/node:6-user
```

The images are tagged with the suffix `-user` to avoid confusion over images that runs as `root`.

## Questions

Please reach out to `node-team@google.com` with any questions!
