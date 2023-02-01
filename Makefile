
SHELL:=/bin/bash

AZURETRE_HOME?="AzureTRE"

include $(AZURETRE_HOME)/Makefile

# Add your make commands down here
define login_acr
$(call target_title, "Logging into $(1) ACR") \
&& az login --service-principal -u $(2) -p $(3) --tenant $(4) \
&& az account set -s $(5) \
&& az acr login -n $(6)
endef

define pull_image_to_devcontainer
$(call target_title, "Pulling $(1) Image") \
&& source <(grep = $(2) | sed 's/ *= */=/g') \
&& docker pull "$(3).azurecr.io/${IMAGE_NAME_PREFIX}/$(1):$${__version__}"
endef

define push_image_from_devcontainer
$(call target_title, "Pushing $(1) Image") \
&& source <(grep = $(2) | sed 's/ *= */=/g') \
&& docker push "$(3).azurecr.io/${IMAGE_NAME_PREFIX}/$(1):$${__version__}"
endef

copy-core-images:
	$(call login_acr, "Source", ${SOURCE_ARM_CLIENT_ID}, ${SOURCE_ARM_CLIENT_SECRET}, ${SOURCE_ARM_TENANT_ID}, ${SOURCE_ARM_SUBSCRIPTION_ID}, ${SOURCE_ACR_NAME})
	$(call pull_image_to_devcontainer, "api", "${AZURETRE_HOME}/api_app/_version.py", ${SOURCE_ACR_NAME})

	$(call login_acr, "Target", ${ARM_CLIENT_ID}, ${ARM_CLIENT_SECRET}, ${ARM_TENANT_ID}, ${ARM_SUBSCRIPTION_ID}, ${ACR_NAME})
	$(call push_image_from_devcontainer, "api", "${AZURETRE_HOME}/api_app/_version.py", ${ACR_NAME})

#pull-resource-processor-vm-porter-image:
#	$(call pull_image,"resource-processor-vm-porter","${AZURETRE_HOME}/resource_processor/_version.py")

#pull-airlock-processor:
#	$(call pull_image,"airlock-processor","${AZURETRE_HOME}/airlock_processor/_version.py")

