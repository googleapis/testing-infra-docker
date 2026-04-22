FROM marketplace.gcr.io/google/debian12:latest

ARG BAZELISK_VERSION=1.28.1
ARG BAZEL_VERSION=7.7.1

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
    python3-pip \
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

# Install Go, build Bazelisk from source, and clean up in a single layer to avoid leaving Go in intermediate layers.
RUN curl -sL https://golang.org/dl/go1.26.2.linux-amd64.tar.gz | tar -C /usr/local -xz && \
    export PATH="/usr/local/go/bin:${PATH}" && \
    git clone https://github.com/bazelbuild/bazelisk.git /tmp/bazelisk && \
    cd /tmp/bazelisk && \
    git checkout v${BAZELISK_VERSION} && \
    go build -o /tools/bazelisk && \
    rm -rf /tmp/bazelisk /usr/local/go

ADD https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-linux-x86_64 /tools/bazel
# Make the tools executable. These operations are performed in separate
# layers to make it easier to determine where vulnerabilities come from.
RUN chmod +x /tools/bazelisk
RUN chmod +x /tools/bazel

WORKDIR /

ENV PATH="/tools:${PATH}" \
    BAZELISK_BIN=/tools/bazelisk \
    BAZEL_BIN=/tools/bazel

# Note: Bazel will use this system-wide configuration file and will merge it
# with other bazelrc file it finds: https://bazel.build/run/bazelrc
COPY bazel.bazelrc /etc/bazel.bazelrc

ENTRYPOINT [ "/bin/bash" ]