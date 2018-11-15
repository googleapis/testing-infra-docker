FROM gcr.io/cloud-devrel-kokoro-resources/python-base:latest

# Install libraries needed by third-party python packages that we depend on.
RUN apt update \
  && apt install -y \
    openssl \
    libffi-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    libpq-dev \
    libmysqlclient-dev \
    libcurl4-openssl-dev \
    libjpeg-dev \
    zlib1g-dev \
    libpng12-dev \
    python-pyaudio \
    libmemcached-dev \
    libmagickwand-dev \
  && apt clean

RUN python --version
RUN which python

# Setup Cloud SDK
ENV CLOUD_SDK_VERSION 182.0.0
# Use system python for cloud sdk.
ENV CLOUDSDK_PYTHON /usr/bin/python
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-$CLOUD_SDK_VERSION-linux-x86_64.tar.gz
RUN tar xzf google-cloud-sdk-$CLOUD_SDK_VERSION-linux-x86_64.tar.gz
RUN /google-cloud-sdk/install.sh
ENV PATH /google-cloud-sdk/bin:$PATH

# Setup the user profile for pip
ENV PATH ~/.local/bin:$PATH

# Install the current version of nox.
RUN python3 -m pip install --user --no-cache-dir nox==2018.10.9

CMD ["nox"]
