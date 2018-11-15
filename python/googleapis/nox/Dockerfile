FROM googleapis/python-multi:latest

# Install openssl (needed for CI services).
RUN apt-get update \
  && apt-get install -y openssl \
  && rm -rf /var/lib/apt/lists/*

# Install the current version of nox.
RUN pip install --no-cache-dir nox-automation==0.18.2

# By default, run nox.
CMD ["nox"]
