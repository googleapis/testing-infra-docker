#!/bin/bash
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script ensures that a Cloud Build trigger exists for each non-root
# cloudbuild.yaml file. Each is triggered on a push to master for any file
# changed in the directory containing that cloudbuild.yaml file.

set -eo pipefail

if [[ $# -ne 1 ]]
then
  echo "Usage: $0 <project>"
  exit 1
fi

project=$1

# change this configuration for testing
branch="master"
repoOwner="googleapis"
repoName="testing-infra-docker"

# find all non-root cloudbuild.yaml configs
for config in $(find -- */ -name 'cloudbuild.yaml' | sort -u)
do
  directory=$(dirname "${config}")
  triggerName=$(dirname "${config}" | sed 's/\//-/g')

  # test to see if the deployment trigger already exists
  if gcloud beta builds triggers describe "${triggerName}" --project="${project}" &>/dev/null
  then
    # trigger already exists, skip
    continue
  fi

  echo "Syncing trigger for ${directory}"

  # create the trigger
  gcloud beta builds triggers create github \
    --project="${project}" \
    --repo-name="${repoName}" \
    --repo-owner="${repoOwner}" \
    --description="Build testing docker images in ${directory}" \
    --included-files="${directory}/**" \
    --name="${triggerName}" \
    --branch-pattern="${branch}" \
    --build-config="${config}"

  # trigger the first deployment
  gcloud beta builds triggers run "${triggerName}" \
    --project="${project}" \
    --branch="${branch}"
done

# find all non-root cloudbuild-test.yaml configs
for config in $(find -- */ -name 'cloudbuild-test.yaml' | sort -u)
do
  directory=$(dirname "${config}")
  triggerName=$(dirname "${config}" | sed 's/\//-/g')-presubmit

  # test to see if the deployment trigger already exists
  if gcloud beta builds triggers describe "${triggerName}" --project="${project}" &>/dev/null
  then
    # trigger already exists, skip
    continue
  fi

  echo "Syncing test trigger for ${directory}"

  # create the trigger
  gcloud beta builds triggers create github \
    --project="${project}" \
    --repo-name="${repoName}" \
    --repo-owner="${repoOwner}" \
    --description="Build testing docker images in ${directory}" \
    --included-files="${directory}/**" \
    --name="${triggerName}" \
    --pull-request-pattern="${branch}" \
    --build-config="${config}"
done
