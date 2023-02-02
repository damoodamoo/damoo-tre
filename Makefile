
SHELL:=/bin/bash

AZURETRE_HOME?="AzureTRE"
AZURECR_HOST="azurecr.io"

include $(AZURETRE_HOME)/Makefile

# Add your make commands down here

copy-core-image:
	$(call target_title, "Copying Core Image for ${IMAGE_NAME}") \
	&& CURRENT_DIR=$$(pwd) \
	&& cd ${DIR} && $${CURRENT_DIR}/.github/scripts/copy_core_image.sh ${IMAGE_NAME} ${IMAGE_VERSION_FILE} ${IMAGE_NAME_PREFIX}

copy-bundle-image:
	$(call target_title, "Copying Bundle for ${DIR}") \
	&& CURRENT_DIR=$$(pwd) \
	&& cd ${DIR} && $${CURRENT_DIR}/.github/scripts/copy_porter_bundle.sh ${IMAGE_NAME_PREFIX}
