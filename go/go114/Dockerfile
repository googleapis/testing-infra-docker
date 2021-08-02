# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang:1.14

# Install python3 for trampoline.
RUN apt-get update && \
    apt-get install -y python3 python3-pip apt-transport-https ca-certificates gnupg && \
    which python3

# Install protoc
RUN apt-get update && apt-get install -y unzip wget vim
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protoc-3.7.1-linux-x86_64.zip
RUN unzip protoc-3.7.1-linux-x86_64.zip
RUN mv bin/protoc /bin/protoc && which protoc

# Install gcloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && apt-get update -y && \
    apt-get install google-cloud-sdk -y

# Install tools used in build
RUN GO111MODULE=on go get honnef.co/go/tools/cmd/staticcheck@latest

WORKDIR $GOPATH
