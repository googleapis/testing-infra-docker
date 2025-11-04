FROM rust:1.85-bookworm

# Install dependencies.
RUN set -ex; \
  apt-get update -y; \
  apt-get install -y \
    git \
    golang-go \
    ;

# Install pyenv.
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
    echo 'export PATH="/root/.pyenv/bin:$PATH"' >> ~/.profile && \
    echo 'export PATH="/root/.pyenv/shims:$PATH"' >> ~/.profile && \
    echo 'eval "$(pyenv init -)"' >> ~/.profile && \
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.profile

ENV PATH="/root/.pyenv/bin:/root/.pyenv/shims:${PATH}"

# Install python.
RUN pyenv install 3.12.10 && \
    pyenv global 3.12.10 && \
    python3 -m pip install --upgrade pip setuptools

ENV PATH="/root/.pyenv/versions/3.12.10/bin:${PATH}"

# Install gcp-uploader and their dependencies.
COPY requirements.txt requirements.txt
RUN python3 -m pip install --require-hashes -r requirements.txt

# Rustdoc generator depedencies.
RUN cargo install --version 0.4.1 cargo-workspaces