# Copyright 2025 Google LLC
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

FROM marketplace.gcr.io/google/ubuntu2404

ENV SYFT_VERSION=1.19.0

# update SSL certs
RUN apt-get update -y && \
    apt-get install -y \
        ca-certificates \
        uuid-runtime \
        git \
        jq \
        zip

RUN mkdir /workspace

WORKDIR /workspace

ADD https://github.com/anchore/syft/releases/download/v${SYFT_VERSION}/syft_${SYFT_VERSION}_linux_amd64.deb /workspace/syft.deb
RUN dpkg -i syft.deb

ENTRYPOINT ["syft"]
