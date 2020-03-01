#!/bin/bash

echo "Creating a Secret to store the Vault TLS certificates..."

kubectl create secret generic vault \
    --from-file=certs/root.crt \
    --from-file=certs/vault.crt \
    --from-file=certs/vault.key


echo "Storing the Vault config in a ConfigMap..."

kubectl create configmap vault --from-file=vault/config.json


echo "Creating the Vault Service..."

kubectl create -f vault/service.yaml


echo "Creating the Vault Deployment..."

kubectl apply -f vault/deployment.yaml

