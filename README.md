This is not an officially supported Google product.

This repository has Docker images used for testing in Google client libraries.

## Updating Images

1. Send a PR to this repo.
2. Once the PR is merged, trigger the appropriate Kokoro job [here](https://fusion.corp.google.com/dashboard/findbuilds?search_pattern=testing-infra-docker&project_types=&include_inactive_projects=false). This will rebuild all the images for a particular language.
