
SHELL:=/bin/bash

AZURETRE_HOME?="AzureTRE"
AZURECR_HOST="azurecr.io"

include $(AZURETRE_HOME)/Makefile

# Add your make commands down here

copy-core-images:
	$(call login_acr,"Source",${SOURCE_ARM_CLIENT_ID},${SOURCE_ARM_CLIENT_SECRET},${SOURCE_ARM_TENANT_ID},${SOURCE_ARM_SUBSCRIPTION_ID},${SOURCE_ACR_NAME})
	$(call pull_image_from_source,"api","api_app/_version.py",${SOURCE_ACR_NAME},${ACR_NAME})
	$(call pull_image_from_source,"resource-processor-vm-porter","resource_processor/_version.py",${SOURCE_ACR_NAME},${ACR_NAME})
	$(call pull_image_from_source,"airlock-processor","airlock_processor/_version.py",${SOURCE_ACR_NAME},${ACR_NAME})

	$(call login_acr,"Target",${ARM_CLIENT_ID},${ARM_CLIENT_SECRET},${ARM_TENANT_ID},${ARM_SUBSCRIPTION_ID},${ACR_NAME})
	$(call push_image_to_target,"api","api_app/_version.py",${ACR_NAME})
	$(call push_image_to_target,"resource-processor-vm-porter","resource_processor/_version.py",${ACR_NAME})
	$(call push_image_to_target,"airlock-processor","airlock_processor/_version.py",${ACR_NAME})

copy-core-image:
	$(call target_title, "Copying Core Image for ${IMAGE_NAME}") \
	&& CURRENT_DIR=$$(pwd) \
	&& cd ${DIR} && $${CURRENT_DIR}/.github/scripts/copy_core_image.sh ${IMAGE_NAME} ${IMAGE_VERSION_FILE} ${IMAGE_NAME_PREFIX}

copy-bundle-image:
	$(call target_title, "Copying Bundle for ${DIR}") \
	&& CURRENT_DIR=$$(pwd) \
	&& cd ${DIR} && $${CURRENT_DIR}/.github/scripts/copy_porter_bundle.sh ${IMAGE_NAME_PREFIX}
