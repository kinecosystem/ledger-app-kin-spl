ifeq ($(BOLOS_SDK),)
$(error BOLOS_SDK is not set)
endif

BOLOS_ENV = bogus

ifeq ($(TARGET_NAME),TARGET_NANOX)
	ICONNAME=icons/nanox_app_solana.gif
else
	ICONNAME=icons/nanos_app_solana.gif
endif

include config.min
include $(BOLOS_SDK)/Makefile.defines

load:
	python3 -m ledgerblue.loadApp $(APP_LOAD_PARAMS)

load-offline:
	python3 -m ledgerblue.loadApp $(APP_LOAD_PARAMS) --offline

delete:
	python3 -m ledgerblue.deleteApp $(COMMON_DELETE_PARAMS)

release:
	@echo "#!/usr/bin/env bash" > install.sh
	@echo "cat <<EOF >> app.hex" >> install.sh
	@cat bin/app.hex >> install.sh
	@echo "EOF" >> install.sh
	export APP_LOAD_PARAMS_EVALUATED="$(shell printf '\\"%s\\" ' $(APP_LOAD_PARAMS:bin/%=%))"; \
	cat install-template.sh | envsubst >> install.sh
	chmod +x install.sh

deps:
	python3 -mpip install ledgerblue
