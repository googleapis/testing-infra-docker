FROM node:6

RUN apt-get update && apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev

RUN cd /tmp && \
wget https://www.python.org/ftp/python/3.7.1/Python-3.7.1.tgz && \
tar -xvf Python-3.7.1.tgz && \
cd Python-3.7.1 && \
./configure && \
make install && \
make altinstall

RUN apt-get install -y python3-pip

USER node
