FROM node:11-stretch

USER node

RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
RUN ls -lah ~/

RUN echo 'export PATH="/home/node/.pyenv/bin:$PATH"' >> ~/.profile
RUN echo 'export PATH="/home/node/.pyenv/shims:$PATH"' >> ~/.profile
RUN echo 'eval "$(pyenv init -)"' >> ~/.profile
RUN echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.profile

ENV PATH="/home/node/.pyenv/bin:/home/node/.pyenv/shims:${PATH}"

RUN pyenv install 3.7.1
RUN pyenv global 3.7.1
