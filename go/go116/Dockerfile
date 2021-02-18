# Copyright 2021 Google LLC
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

FROM golang:1.16

# Install python3 for trampoline.
RUN apt-get update && apt-get install -y python3 python3-pip && which python3

# Install protoc
RUN apt-get update && apt-get install -y unzip wget vim
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v3.13.0/protoc-3.13.0-linux-x86_64.zip
RUN unzip protoc-3.13.0-linux-x86_64.zip
RUN mv bin/protoc /bin/protoc && which protoc

# Install gcloud SDK
RUN mkdir -p /usr/local/gcloud && \
    curl -sSL https://sdk.cloud.google.com | bash -s -- --install-dir=/usr/local/gcloud

# Install tools used in build
RUN go install honnef.co/go/tools/cmd/staticcheck@latest

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

WORKDIR $GOPATH
