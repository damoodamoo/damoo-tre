#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
# Uncomment this line to see each command for debugging (careful: this will show secrets!)
# set -o xtrace

COMMIT_SHA=${1}
ENVIRONMENT=${2}

SHA_IN_ENV_BRANCH=$(git branch --contains "${COMMIT_SHA}" | grep -w "${ENVIRONMENT}}")
echo "${SHA_IN_ENV_BRANCH}"
[[ -z "${SHA_IN_ENV_BRANCH}" ]] && echo "Commit is not in ${ENVIRONMENT} branch. Cannot deploy." && exit 1
