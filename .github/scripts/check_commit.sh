#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
# Uncomment this line to see each command for debugging (careful: this will show secrets!)
#set -o xtrace

echo "8"
COMMIT_SHA="${1}"
ENVIRONMENT="${2}"
echo "11"

git --version
echo "14"

git config user.name "GitHub Actions Bot"
git config user.email "<>"

git fetch

git branch --contains 5bb71c81894811bd9aac0914b0999ae9fb77b1ab

SHA_IN_ENV_BRANCH=$(git branch --contains "${COMMIT_SHA}")

grep --version
echo "24"
SHA_IN_ENV_BRANCH=$(git branch --contains "${COMMIT_SHA}" | grep -w "${ENVIRONMENT}")
echo "18"
# echo "${SHA_IN_ENV_BRANCH}"

# if [[ -z "${SHA_IN_ENV_BRANCH}" ]] ; then
#   echo "Commit is not in ${ENVIRONMENT} branch. Cannot deploy."
#   exit 1
# fi

# echo "Commit ${COMMIT_SHA} found in ${ENVIRONMENT} branch. Continuing."
