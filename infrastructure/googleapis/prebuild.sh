#!/bin/bash

set -eo pipefail

env
pwd
bazel --version

mkdir output
OUTPUT_DIR=$(realpath output)

echo "Precompile Ruby"
git clone --depth 1 https://github.com/googleapis/gapic-generator-ruby.git
pushd gapic-generator-ruby
bazel build //rules_ruby_gapic/gapic-generator:gapic_generator_bundled_context
popd

RUBY_DIRECTORY=$(ls -d .cache/bazel/*/*/external/gapic_generator_ruby_runtime)
RUBY_VERSION=$(echo 'puts RUBY_VERSION' | "${RUBY_DIRECTORY}/bin/ruby")
echo "Ruby version: $RUBY_VERSION, packing..."
RUBY_ARCHIVE_DIR="ruby-$RUBY_VERSION"
RUBY_TARBALL_FILENAME="ruby-${RUBY_VERSION}_glinux_x86_64.tar.gz"
mkdir -p "$RUBY_ARCHIVE_DIR"
cp -r "$RUBY_DIRECTORY"/bin "$RUBY_DIRECTORY"/include "$RUBY_DIRECTORY"/lib "$RUBY_ARCHIVE_DIR"
tar cfz "${OUTPUT_DIR}/${RUBY_TARBALL_FILENAME}" "$RUBY_ARCHIVE_DIR"
echo "Done: $RUBY_TARBALL_FILENAME"
ls -alh "${OUTPUT_DIR}/${RUBY_TARBALL_FILENAME}"

echo "Precompiling PHP"
git clone --depth 1 https://github.com/googleapis/gapic-generator-php.git
pushd gapic-generator-php
bazel build //rules_php_gapic:php_gapic_generator_binary
popd

PHP_DIRECTORY=$(ls -d .cache/bazel/*/*/external/php_micro)
PHP_VERSION=$(echo '<? echo phpversion(); ?>' | "${PHP_DIRECTORY}/bin/php")

echo "PHP version: $PHP_VERSION, packing..."
PHP_ARCHIVE_DIR="php-$PHP_VERSION"
PHP_TARBALL_FILENAME="php-${PHP_VERSION}_linux_x86_64.tar.gz"
mkdir -p "$PHP_ARCHIVE_DIR"
cp -r "$PHP_DIRECTORY"/bin "$PHP_DIRECTORY"/include "$PHP_DIRECTORY"/lib "$PHP_ARCHIVE_DIR"
tar cfz "${OUTPUT_DIR}/${PHP_TARBALL_FILENAME}" "$PHP_ARCHIVE_DIR"
echo "Done: $PHP_TARBALL_FILENAME"
ls -alh "${OUTPUT_DIR}/${PHP_TARBALL_FILENAME}"
