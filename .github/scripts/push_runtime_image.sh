#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
# Uncomment this line to see each command for debugging (careful: this will show secrets!)
# set -o xtrace

# is there a custom runtime image we need to get?
if [ "$(yq eval ".custom.runtime_image.build" porter.yaml)" == "null" ]; then
  echo "Runtime image build section isn't specified. Exiting..."
  exit 0
fi

image_name=$(yq eval ".custom.runtime_image.name" porter.yaml)
version_file=$(yq eval ".custom.runtime_image.build.version_file" porter.yaml)
version_line=$(cat "${version_file}")

# doesn't work with quotes
# shellcheck disable=SC2206
version_array=( ${version_line//=/ } ) # split by =
version="${version_array[1]//\"}" # second element is what we want, remove " chars

echo "Pushing ${image_name} version ${version} to target..."

docker push "${ACR_NAME}.azurecr.io/${1}/${image_name}:${version}"
