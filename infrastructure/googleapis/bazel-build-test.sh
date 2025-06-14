#!/bin/bash

set -eo pipefail

env
pwd

echo "Check bazel build"
git clone --depth 1 https://github.com/googleapis/googleapis.git
pushd googleapis
bazelisk --version
bazelisk build //google/example/library/v1/...

OUTPUT_DIR=$(bazelisk info bazel-bin)

find "${OUTPUT_DIR}" -name "gapi-cloud-example-library-v1-go.tar.gz" | grep .
find "${OUTPUT_DIR}" -name "google-cloud-example-library-v1-java.tar.gz" | grep .
find "${OUTPUT_DIR}" -name "google-cloud-example-library-v1-ruby.tar.gz" | grep .
find "${OUTPUT_DIR}" -name "google-cloud-example-library-v1-php.tar.gz" | grep .
find "${OUTPUT_DIR}" -name "google-cloud-example-library-v1-csharp.tar.gz" | grep .
find "${OUTPUT_DIR}" -name "example-library-v1-py.tar.gz" | grep .
find "${OUTPUT_DIR}" -name "example-library-v1-nodejs.tar.gz" | grep .

popd
