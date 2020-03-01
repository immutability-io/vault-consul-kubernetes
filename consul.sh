#!/bin/bash

echo "Generating the Gossip encryption key..."

export GOSSIP_ENCRYPTION_KEY=$(consul keygen)

echo "Create namespace"

kubectl apply -f consul/namespace.yml

echo "Create service account"

kubectl apply -f consul/serviceaccount.yml

echo "Creating the Consul Secret to store the Gossip key and the TLS certificates..."

kubectl -n consul create secret generic consul \
  --from-literal="gossip-encryption-key=${GOSSIP_ENCRYPTION_KEY}" \
  --from-file=certs/ca.pem \
  --from-file=certs/consul.pem \
  --from-file=certs/consul-key.pem


echo "Storing the Consul config in a ConfigMap..."

kubectl -n consul create configmap consul --from-file=consul/config.json

echo "Creating the Consul Service..."

kubectl create -f consul/service.yaml


echo "Creating the Consul StatefulSet..."

kubectl create -f consul/statefulset.yaml

