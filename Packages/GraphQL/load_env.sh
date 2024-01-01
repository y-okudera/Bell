#!/bin/bash

# Download envsubst if not exists.
if [ ! -e ./vendor/envsubst ]; then
    curl -L https://github.com/a8m/envsubst/releases/download/v1.2.0/envsubst-`uname -s`-`uname -m` -o envsubst
    chmod +x envsubst
    mkdir -p ./vendor/
    mv envsubst ./vendor/
fi

# Load .env file.
set -a; source ./.env; set +a;
./vendor/envsubst < ./templates/Env.swift > ./Sources/Infra/Generated/Env.generated.swift
