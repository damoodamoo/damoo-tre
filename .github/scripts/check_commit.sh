#!/bin/bash
set -e

# Uncomment this line to see each command for debugging (careful: this will show secrets!)
#set -o xtrace

COMMIT_SHA="${1}"
ENVIRONMENT="${2}"

SHA_IN_ENV_BRANCH=$(git branch -r --contains "${COMMIT_SHA}" | grep -w "origin/${ENVIRONMENT}")

echo "${SHA_IN_ENV_BRANCH}"

if [[ -z "${SHA_IN_ENV_BRANCH}" ]] ; then
  echo "Commit is not in ${ENVIRONMENT} branch. Cannot deploy."
  exit 1
fi

# echo "Commit ${COMMIT_SHA} found in ${ENVIRONMENT} branch. Continuing."
