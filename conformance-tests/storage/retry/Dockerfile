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
FROM python:3.8@sha256:5ce685b86b4ac5ee15ef602af37581c3536de6ec93d52ad1d78abd7c3488a64e

EXPOSE 9000
WORKDIR /opt/storage-emulator

COPY google-cloud-cpp/google/cloud/storage/emulator /opt/storage-emulator/

RUN python3 -m pip install -r requirements.txt

CMD ["gunicorn", "--bind", "localhost:9000", "--worker-class", "sync", "emulator:run()"]
