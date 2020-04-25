This is not an officially supported Google product.

This repository has Docker images used for testing in Google client libraries.

## Updating Images

1. Send a PR to this repo.
2. Once the PR is merged, Cloud Build will rebuild the images for any images that were updated.
   See the project ``cloud-devrel-kokoro-resources`` to edit or add Cloud Build triggers.