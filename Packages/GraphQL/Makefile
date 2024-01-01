.PHONY: setup load-env codegen

CONFIG_FILE_PATH = ./apollo-codegen-config.json
ifneq ("$(wildcard $(CONFIG_FILE_PATH))","")
	CONFIG_FILE_EXISTS = 1
endif

define doInit
	./apollo-ios-cli init --schema-namespace GitHub --module-type swiftPackageManager
endef

define message
	@echo "apollo-codegen-config.json already exist"
endef

setup: load-env
	swift package --allow-writing-to-package-directory apollo-cli-install
	$(if $(CONFIG_FILE_EXISTS), $(message), $(doInit))

load-env:
	chmod +x load_env.sh
	sh load_env.sh

codegen:
	./apollo-ios-cli generate
