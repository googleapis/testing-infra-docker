#!/bin/bash
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
set -o errexit -o nounset -o pipefail

__SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function main() { (
  docker_image=$1

  cd "$__SCRIPT_DIR"

  short_sha="${SHORT_SHA:-${BASE_TAG}}"

  clone_args=""
  if [[ "${CPP_COMMITISH}" != "default" ]]; then
    clone_args="--branch $CPP_COMMITISH"
  fi

  msg "cloning google-cloud-cpp repo..."
  git clone $clone_args https://github.com/googleapis/google-cloud-cpp.git google-cloud-cpp
  msg "cloning google-cloud-cpp repo complete"
  cpp_sha=$(cd google-cloud-cpp && git rev-parse --verify HEAD)
  msg "SHA of google-cloud-cpp: $cpp_sha"
  cpp_short_sha=${cpp_sha:0:10}
  msg "Short SHA of google-cloud-cpp: $cpp_short_sha"

  tag="${short_sha}_server-${cpp_short_sha}"

  img_tag="$docker_image:$tag"

  msg "Building docker image $img_tag..."
  docker build -t "$img_tag" .
  msg "Building docker image $img_tag complete"

  msg "Pushing docker image $img_tag..."
  docker push "$img_tag"
  msg "Pushing docker image $img_tag complete"

) }

function now { date +"%Y-%m-%d %H:%M:%S" | tr -d '\n' ;}
function msg { println "$*" >&2 ;}
function println { printf '%s\n' "$(now) $*" ;}

main $@
