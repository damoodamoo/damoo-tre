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

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# if there is a runtime image for this bundle, pull it
"${SCRIPT_DIR}/pull_runtime_image.sh" "${1}"

# download the bundle by name and version
BUNDLE_NAME=$(yq eval ".name" porter.yaml)
BUNDLE_VER=$(yq eval ".version" porter.yaml)

echo "Downloading bundle ${BUNDLE_NAME}:v${BUNDLE_VER}"
porter archive "${BUNDLE_NAME}.tgz" --reference "${SOURCE_ACR_NAME}.azurecr.io/${BUNDLE_NAME}:v${BUNDLE_VER}"

# push it to the target registry
az login --service-principal -u "${ARM_CLIENT_ID}" -p "${ARM_CLIENT_SECRET}" --tenant "${ARM_TENANT_ID}"
az account set -s "${ARM_SUBSCRIPTION_ID}"
az acr login -n "${ACR_NAME}"

# if there is a runtime image, push it
"${SCRIPT_DIR}/push_runtime_image.sh" "${1}"

porter publish --archive "${BUNDLE_NAME}.tgz" --reference "${ACR_NAME}.azurecr.io/${BUNDLE_NAME}:v${BUNDLE_VER}" --force
