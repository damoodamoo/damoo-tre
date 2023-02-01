
SHELL:=/bin/bash

AZURETRE_HOME?="AzureTRE"

include $(AZURETRE_HOME)/Makefile

# Add your make commands down here

define pull_image
$(call target_title, "Pulling $(1) Image") \
&& . ${AZURETRE_HOME}/devops/scripts/check_dependencies.sh env \
&& . ${AZURETRE_HOME}/devops/scripts/set_docker_sock_permission.sh \
&& source <(grep = $(2) | sed 's/ *= */=/g') \
&& az login --service-principal -u $${ARM_CLIENT_ID} -p $${ARM_CLIENT_SECRET} --tenant $${ARM_TENANT_ID}
&& az acr login -n $${ACR_NAME} \
&& docker pull "${FULL_IMAGE_NAME_PREFIX}/$(1):$${__version__}"
endef

pull-core-images:
	$(call pull_image,"api","${AZURETRE_HOME}/api_app/_version.py")

#pull-resource-processor-vm-porter-image:
#	$(call pull_image,"resource-processor-vm-porter","${AZURETRE_HOME}/resource_processor/_version.py")

#pull-airlock-processor:
#	$(call pull_image,"airlock-processor","${AZURETRE_HOME}/airlock_processor/_version.py")

