#!/bin/bash
# Copyright 2018 Google LLC
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

docker build -t gcr.io/cloud-devrel-kokoro-resources/node:6-user 6-user
docker build -t gcr.io/cloud-devrel-kokoro-resources/node:8-user 8-user
docker build -t gcr.io/cloud-devrel-kokoro-resources/node:10-user 10-user
docker build -t gcr.io/cloud-devrel-kokoro-resources/node:11-user 11-user

docker push gcr.io/cloud-devrel-kokoro-resources/node
