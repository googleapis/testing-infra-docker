FROM node:14

# Taken from
# https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#running-puppeteer-in-docker

# See https://crbug.com/795759
RUN apt-get update && apt-get install -yq libgconf-2-4

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
RUN apt-get update && apt-get install -y wget --no-install-recommends \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /src/*.deb

# It's a good idea to use dumb-init to help prevent zombie chrome processes.
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

# Run everything after as non-privileged user.
USER node

# Setup Cloud SDK
WORKDIR /home/node
ENV CLOUD_SDK_VERSION=303.0.0 \
    CLOUDSDK_PYTHON=/usr/bin/python \
    PATH=/home/node/google-cloud-sdk/bin:$PATH
RUN set -ex; \
    curl -LO https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-$CLOUD_SDK_VERSION-linux-x86_64.tar.gz; \
    tar xzf google-cloud-sdk-$CLOUD_SDK_VERSION-linux-x86_64.tar.gz; \
    rm google-cloud-sdk-$CLOUD_SDK_VERSION-linux-x86_64.tar.gz
RUN set -ex; \
    ./google-cloud-sdk/install.sh; \
    gcloud config set core/disable_usage_reporting true; \
    gcloud config set component_manager/disable_update_check true; \
    gcloud --quiet components update; \
    gcloud --quiet components install beta

ENTRYPOINT ["dumb-init", "--"]
