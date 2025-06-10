FROM marketplace.gcr.io/google/debian12:latest

ARG BAZELISK_VERSION=1.26.0
ARG BAZEL_VERSION=7.6.1

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    apt-utils \
    curl \
    zip \
    build-essential \
    python-dev-is-python3 \
    openjdk-17-jdk \
    python3-dev \
    pkg-config \
    openssl \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libyaml-dev \
    git \
    && apt-get clean

RUN mkdir -p /tools

# Add bazelisk and bazel CLIs
ADD https://github.com/bazelbuild/bazelisk/releases/download/v${BAZELISK_VERSION}/bazelisk-linux-amd64 /tools/bazelisk
ADD https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-linux-x86_64 /tools/bazel
RUN chmod +x /tools/bazelisk /tools/bazel

WORKDIR /

ENV PATH="/tools:${PATH}" \
    BAZELISK_BIN=/tools/bazelisk \
    BAZEL_BIN=/tools/bazel

# Note: Bazel will use this system-wide configuration file and will merge it
# with other bazelrc file it finds: https://bazel.build/run/bazelrc
COPY bazel.bazelrc /etc/bazel.bazelrc

ENTRYPOINT [ "/bin/bash" ]