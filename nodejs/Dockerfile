FROM ubuntu:latest
RUN apt-get update && \
    apt-get upgrade -y -q && \
    apt-get install -y -q curl
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
CMD /bin/bash
