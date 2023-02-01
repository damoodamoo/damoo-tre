#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
# Uncomment this line to see each command for debugging (careful: this will show secrets!)
# set -o xtrace

# login to source repo
az login --service-principal -u "${SOURCE_ARM_CLIENT_ID}" -p "${SOURCE_ARM_CLIENT_SECRET}" --tenant "${SOURCE_ARM_TENANT_ID}"
az account set -s "${SOURCE_ARM_SUBSCRIPTION_ID}"
az acr login -n "${SOURCE_ACR_NAME}"

IMAGE_NAME=${1}
VERSION_FILE=${2}
IMAGE_PREFIX=${3}

echo "${1} - ${2} - ${3}"

# shellcheck disable=SC1090
source <(grep '=' "${VERSION_FILE}" | sed 's/ *= */=/g')
# shellcheck disable=SC2154
IMAGE_VER="${__version__}"

echo "Pulling ${IMAGE_NAME}:${IMAGE_VER} from Source..."
docker pull "${SOURCE_ACR_NAME}.azurecr.io/${IMAGE_PREFIX}/${IMAGE_NAME}:${IMAGE_VER}"
docker image tag "${SOURCE_ACR_NAME}.azurecr.io/${IMAGE_PREFIX}/${IMAGE_NAME}:${IMAGE_VER}" "${ACR_NAME}.azurecr.io/${IMAGE_PREFIX}/${IMAGE_NAME}:${IMAGE_VER}"

# push it to the target registry
az login --service-principal -u "${ARM_CLIENT_ID}" -p "${ARM_CLIENT_SECRET}" --tenant "${ARM_TENANT_ID}"
az account set -s "${ARM_SUBSCRIPTION_ID}"
az acr login -n "${ACR_NAME}"

echo "Pulling ${IMAGE_NAME}:${IMAGE_VER} to Target..."
docker push "${ACR_NAME}.azurecr.io/${IMAGE_PREFIX}/${IMAGE_NAME}:${IMAGE_VER}"
