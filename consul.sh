#!/bin/bash


echo "Generating the Gossip encryption key..."

export GOSSIP_ENCRYPTION_KEY=$(consul keygen)


echo "Creating the Consul Secret to store the Gossip key and the TLS certificates..."

kubectl create secret generic consul \
    --from-literal="gossip-encryption-key=${GOSSIP_ENCRYPTION_KEY}" \
    --from-file=certs/root.crt \
    --from-file=certs/vault.crt \
    --from-file=certs/vault.key


echo "Storing the Consul config in a ConfigMap..."

kubectl create configmap consul --from-file=consul/config.json


echo "Creating the Consul Service..."

kubectl create -f consul/service.yaml


echo "Creating the Consul StatefulSet..."

kubectl create -f consul/statefulset.yaml

