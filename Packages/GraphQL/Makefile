.PHONY: setup load-env codegen

setup: load-env
	swift package --allow-writing-to-package-directory apollo-cli-install
	./apollo-ios-cli init --schema-namespace GitHub --module-type swiftPackageManager
	./apollo-ios-cli generate

load-env:
	chmod +x load_env.sh
	sh load_env.sh

codegen:
	./apollo-ios-cli generate
